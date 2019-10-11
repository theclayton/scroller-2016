//
//  SearchViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 7/21/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class MySongsViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    //PARSER ISH
    var parser: XMLParser!
    var element: String = ""
    var endElement: String = ""
    var songName: String = ""
    var songComposer: String = ""
    var songFileName: String = ""
    
    var songArray = [Song]()
    var fileArray = [String]()
    var filteredSongs = [Song]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var meteadataXMLString: String = ""
  
    
    @IBAction func unwindToMySongs(segue: UIStoryboardSegue) {
        beginParsing()
    }
    @IBAction func unwindToMySongsFromLoggin(segue: UIStoryboardSegue) {}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)

        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        listTableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.light
        (UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])).tintColor = UIColor.black
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn == false {
            //show login/create account view
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "loggedOut") as! LoggedOutViewController
            self.present(secondViewController, animated: true, completion: nil)
        } else {
            let launchedBefore = UserDefaults.standard.bool(forKey: "firstLaunch")
            if launchedBefore == false {
                print("First launch, setting NSUserDefaults.")
                
                UserDefaults.standard.set(true, forKey: "firstLaunch")
                UserDefaults.standard.set(2, forKey: "savedCountdown")
                UserDefaults.standard.set(true, forKey: "showNoteHighlighter")
                
                createFiles()
            }
            
            searchForNewFiles()
            beginParsing()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn == true {
            rewriteXML()
            saveMetadata()
        }
    }
    func applicationDidBecomeActive(notification: NSNotification) {
        searchForNewFiles()
    }
    
    
    func searchForNewFiles() {
        let fileChecker = checkForSongs()
        if fileChecker.areThereMissingSongs() == true {
            let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newSongMetadata") as! newSongMetadataViewController
            secondViewController.missingSongs = fileChecker.missingSongs
            present(secondViewController, animated: true, completion: nil)
        }
    }
    
    func createFiles() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        // 0 // Delete previous document directory
        do {
            if let contents = try? FileManager.default.contentsOfDirectory(atPath: dirPath) {
                for path in contents {
                    let fullPath = (dirPath as NSString).appendingPathComponent(path)
                    try? FileManager.default.removeItem(atPath: fullPath)
                }
            }
        }
        
        // 1 // Copy Fur Elise to doc directory
        let bundlePath = Bundle.main.path(forResource: "10000002", ofType: ".xml")
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let furElistDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent("10000002.xml")
        do{
            try FileManager.default.copyItem(atPath: bundlePath!, toPath: (furElistDestPath?.path)!)
        } catch {
            print("\n Could not copy 10000002.xml file\n")
        }
        
        // 2 // Create folder called metadata
        let metadataPath = (dirPath as NSString).appendingPathComponent("metadata")
        do {
            try FileManager.default.createDirectory(atPath: metadataPath, withIntermediateDirectories: false, attributes: nil)
        } catch {
            print("metadata folder exists")
        }
        
        // 3 // Create folder called setlists
        let setlistPath = (dirPath as NSString).appendingPathComponent("setlists")
        do {
            try FileManager.default.createDirectory(atPath: setlistPath, withIntermediateDirectories: false, attributes: nil)
        } catch {
            print("setlists folder exists")
        }
        
        // 4 // Save metadata.xml to metadata folder
        let metadataXMLString = "<Metadata></Metadata>"
        let destPathForMetadataXML = NSURL(fileURLWithPath: destPath).appendingPathComponent("metadata/metadata.xml")
        do {
            try metadataXMLString.write(toFile: (destPathForMetadataXML?.path)!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("\n Could not create Metadata.xml file\n")
        }
    }
    /* SHARED CONTAINER CODE
     let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.flaresoftware.scroller")
     let destPath = NSURL(fileURLWithPath: (groupURL?.path)!).appendingPathComponent("10000002.xml")
     */

    
    func rewriteXML() {
        //rewrite metadata file
        meteadataXMLString = "<Metadata>"
        
        if songArray.count > 0 {
            for i in 0...songArray.count-1 {
                meteadataXMLString.append("<Song><Name>\(songArray[i].songName)</Name><Composer>\(songArray[i].songComposer)</Composer><FileName>\(songArray[i].songFileName)</FileName></Song>")
                if i >= songArray.count-1 {
                    meteadataXMLString.append("</Metadata>")
                }
            }
        } else {
            meteadataXMLString = "<Metadata></Metadata>"
        }
    }
    func saveMetadata() {
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let destPathForXML = NSURL(fileURLWithPath: destPath).appendingPathComponent("metadata/metadata.xml")
        do {
            try meteadataXMLString.write(toFile: (destPathForXML?.path)!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("\n Could not create setlist file\n")
        }
    }
    
    
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if listTableView.isEditing == true {
            listTableView.setEditing(false, animated: true)
            editButton.title = "edit"
        } else {
            listTableView.setEditing(true, animated: true)
            editButton.title = "done"
        }
    }
    
    
    
    func checkIfSongsExists() {
        findSetlistDirContents()
        var songsToKeep = [Song]()
        
        if fileArray.count > 0 {
            for songIndex in 0..<songArray.count {
                let thisFile = songArray[songIndex].songFileName
                var doesExist: Bool = false
                
                for file in 0..<fileArray.count {
                    let existingFile: String = "\(fileArray[file]).xml"
                    if thisFile == existingFile {
                        doesExist = true
                    }
                }
                if doesExist == true {
                    songsToKeep.append(songArray[songIndex])
                }
            }
        }
        songArray = songsToKeep
    }
    func findSetlistDirContents() {
        fileArray.removeAll()
        let dirPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsURL = dirPaths[0]
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: docsURL, includingPropertiesForKeys: nil, options: [])
            let xmlFiles = directoryContents.filter{ $0.pathExtension == "xml" }
            let xmlFileNames = xmlFiles.map{ $0.deletingPathExtension().lastPathComponent }
            fileArray.append(contentsOf: xmlFileNames)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    func moreOptionsPressed(sender: UIButton) {
        var thisIndex: Int = sender.tag
        if searchController.isActive && searchController.searchBar.text != "" {
            for i in 0..<songArray.count {
                let songInSongArray: String = songArray[i].songFileName
                if songInSongArray == filteredSongs[sender.tag].songFileName {
                    thisIndex = i
                }
            }
        }
        
        if thisIndex >= 0 {
            let alertController = UIAlertController(title: "\(songArray[thisIndex].songName)", message: "\(songArray[thisIndex].songComposer)", preferredStyle: .actionSheet)
            
            let addSetlistAction = UIAlertAction(title: "Add to Setlist", style: .default) { (_) in
                let contentView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectSetlistView") as! selectSetlistViewController
                contentView.modalPresentationStyle = UIModalPresentationStyle.popover
                contentView.thisSong = self.songArray[thisIndex]
                let _popoverPresentationController = contentView.popoverPresentationController!
                _popoverPresentationController.delegate = self
                _popoverPresentationController.permittedArrowDirections = .any
                _popoverPresentationController.sourceView = sender
                self.present(contentView, animated: true, completion: nil)
            }
            let editSongInfo = UIAlertAction(title: "Edit Song Info", style: .default) { (_) in
                self.editSongInfo(index: thisIndex, indexFilter: sender.tag)
            }
            let shareSong = UIAlertAction(title: "Share Song", style: .default) { (_) in
                self.shareSong(index: thisIndex)
            }
            let deleteSongAction = UIAlertAction(title: "Delete Song", style: .destructive) { (_) in
                self.deleteSong(index: thisIndex)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(addSetlistAction)
            alertController.addAction(editSongInfo)
            alertController.addAction(shareSong)
            alertController.addAction(deleteSongAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    func shareSong(index: Int) {
        let urlpath = getDocumentsDirectory().appendingPathComponent("\(songArray[index].songFileName)")
        let xmlFile: URL = URL(fileURLWithPath: urlpath)
        let objectsToShare = [xmlFile]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    func editSongInfo(index: Int, indexFilter: Int) {
        let alert = UIAlertController(title: "Edit Song Info", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (nameTextField) in
            nameTextField.text = "\(self.songArray[index].songName)"
            nameTextField.autocapitalizationType = UITextAutocapitalizationType.sentences
        }
        alert.addTextField { (composerTextField) in
            composerTextField.text = "\(self.songArray[index].songComposer)"
            composerTextField.autocapitalizationType = UITextAutocapitalizationType.words
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in }))
        alert.addAction(UIAlertAction(title: "Set", style: .default, handler: { (_) in
            let nameTextField = alert.textFields![0]
            let composerTextField = alert.textFields![1]
            if nameTextField.text != "" && composerTextField.text != "" {
                //save name and composer
                let fileName: String = self.songArray[index].songFileName
                if self.searchController.isActive && self.searchController.searchBar.text != "" {
                    let fileNameFiltered: String = self.songArray[indexFilter].songFileName
                    self.filteredSongs[indexFilter] = Song(songName: nameTextField.text!, songComposer: composerTextField.text!, songFileName: fileNameFiltered)
                }
                self.songArray[index] = Song(songName: nameTextField.text!, songComposer: composerTextField.text!, songFileName: fileName)
                self.rewriteXML()
                self.saveMetadata()
                self.listTableView.reloadData()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func deleteSong(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)

        //delete file
        let fileManager = FileManager.default
        let xmlFile = getDocumentsDirectory().appendingPathComponent("\(songArray[index].songFileName)")
        do {
            try fileManager.removeItem(atPath: xmlFile)
        } catch let error as NSError {
            print("Could not delete \(songArray[index].songFileName): \(error)")
        }
        songArray.remove(at: index)
        listTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    
    //PARSER ISH
    func beginParsing()
    {
        let urlpath: String = getDocumentsDirectory().appendingPathComponent("metadata/metadata.xml")
        let url: URL = URL(fileURLWithPath: urlpath)
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        
        songArray.removeAll()
        songName = ""
        songComposer = ""
        songFileName = ""
        
        parser.parse()
        checkIfSongsExists()
        listTableView.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual("Name") {
            songName.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        if element.isEqual("Composer") {
            songComposer.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        if element.isEqual("FileName") {
            songFileName.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        endElement = elementName
        
        if (endElement == "Song") {
            songArray.append(Song(songName: songName, songComposer: songComposer, songFileName: songFileName))
            songName = ""
            songComposer = ""
            songFileName = ""
        }
    }
    
    
    // MARK: TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredSongs.count
        } else {
            return songArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell
        
        let song: Song
        if searchController.isActive && searchController.searchBar.text != "" {
            song = filteredSongs[indexPath.row]
        } else {
            songArray.sort(by: { $0.songName < $1.songName})
            song = songArray[indexPath.row]
        }
        
        cell.TitleLabel.text = song.songName
        cell.SubtitleLabel.text = song.songComposer
        cell.moreOptionsButton.tag = indexPath.row
        cell.moreOptionsButton.addTarget(self, action: #selector(moreOptionsPressed(sender:)), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func filterContentForSearchText(searchText: String) {
        filteredSongs = songArray.filter({( song : Song) -> Bool in
            let nameAndComposer = song.songName + song.songComposer
            return nameAndComposer.lowercased().contains(searchText.lowercased())
        })
        listTableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }

    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showScroller" {
            if let indexPath = listTableView.indexPathForSelectedRow {
                if searchController.isActive && searchController.searchBar.text != "" {
                    let controller = (segue.destination) as! ScrollerViewController
                    controller.scrollerTitle = filteredSongs[indexPath.row].songName
                    controller.scrollerFile = filteredSongs[indexPath.row].songFileName
                } else {
                    let controller = (segue.destination) as! ScrollerViewController
                    controller.scrollerTitle = songArray[indexPath.row].songName
                    controller.scrollerFile = songArray[indexPath.row].songFileName
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
