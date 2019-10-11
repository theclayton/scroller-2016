//
//  setlistsSongsViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 9/16/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class SetlistsSongsViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var songArray = [Song]()
    var fileArray = [String]()
    
    //PARSER ISH
    var parser: XMLParser!
    var element: String = ""
    var endElement: String = ""
    var songName: String = ""
    var songComposer: String = ""
    var songFileName: String = ""

    var thisSetlistName: String = ""
    var setlistXMLString: String = ""

    
    @IBAction func unwindToSongs(segue: UIStoryboardSegue) {
        beginParsing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = thisSetlistName
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        beginParsing()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rewriteXML()
        saveSetlists()
    }

    
    func rewriteXML() {
        //rewrite setlist file
        setlistXMLString = "<Metadata>"
        
        if songArray.count > 0 {
            for i in 0...songArray.count-1 {
                setlistXMLString.append("<Song><Name>\(songArray[i].songName)</Name><Composer>\(songArray[i].songComposer)</Composer><FileName>\(songArray[i].songFileName)</FileName></Song>")
                if i >= songArray.count-1 {
                    setlistXMLString.append("</Metadata>")
                }
            }
        } else {
            setlistXMLString = "<Metadata></Metadata>"
        }
    }
    func saveSetlists() {
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let destPathForXML = NSURL(fileURLWithPath: destPath).appendingPathComponent("setlists/\(thisSetlistName).xml")
        do {
            try setlistXMLString.write(toFile: (destPathForXML?.path)!, atomically: true, encoding: String.Encoding.utf8)
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
    @IBAction func addButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showSongSelector", sender: self)
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
    

    //PARSER ISH
    func beginParsing()
    {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: String = paths[0] as String
        let urlpath: String = (documentsDirectory as NSString).appendingPathComponent("setlists/\(thisSetlistName).xml")
        let url:URL = URL(fileURLWithPath: urlpath)
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

    
    // MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        
        cell.textLabel?.text = songArray[indexPath.row].songName
        cell.detailTextLabel?.text = songArray[indexPath.row].songComposer
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listTableView.isUserInteractionEnabled = false
            songArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        listTableView.isUserInteractionEnabled = true
        listTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = songArray[sourceIndexPath.row]
        songArray.remove(at: sourceIndexPath.row)
        songArray.insert(itemToMove, at: destinationIndexPath.row)
    }

    
    
    //SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showScroller" {
            if let indexPath = listTableView.indexPathForSelectedRow {
                let controller = (segue.destination) as! ScrollerViewController
                controller.scrollerTitle = songArray[indexPath.row].songName
                controller.scrollerFile = songArray[indexPath.row].songFileName
            }
        } else if segue.identifier == "showSongSelector" {
            let vc = segue.destination as UIViewController
            let popController = vc.popoverPresentationController
            if popController != nil {
                popController?.delegate = self
            }
            let controller = (segue.destination) as! selectSongsViewController
            controller.thisSetlistName = thisSetlistName
            controller.SongArray = songArray
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
