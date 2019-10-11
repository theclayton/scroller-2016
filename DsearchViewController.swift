//
//  DsearchViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 7/21/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class DsearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate, UISearchBarDelegate, UISearchResultsUpdating, URLSessionDownloadDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var getSongsSession: URLSession!
    var downloadURLTask: URLSessionDownloadTask!
    var isDownloading: Bool = false
    var thisIndex: Int = 0
  
    //PARSER ISH
    var parser: XMLParser!
    var element: String = ""
    var endElement: String = ""
    
    var allSongsArray = [Song]()
    
    var songName: String = ""
    var songComposer: String = ""
    var songFileName: String = ""
    //
    
    @IBOutlet weak var loadingView: UIView!
    
    //SEARCH STUFF
    var filteredSongs = [Song]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        listTableView.tableHeaderView = searchController.searchBar
        
        navigationController?.navigationBar.barTintColor = UIColor.scrollerDiscovery()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        searchController.searchBar.barTintColor = UIColor.scrollerDiscovery()
        searchController.searchBar.tintColor = UIColor.scrollerDiscovery()
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.light
        tabBarController?.tabBar.barTintColor = UIColor.white
        (UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])).tintColor = UIColor.white
        tabBarController?.tabBar.tintColor = UIColor(red: 50.0/255.0, green: 100.0/255.0, blue: 160.0/255.0, alpha: 1.0)
        
        loadingView.isHidden = false
        loadingView.layer.cornerRadius = 5
        loadingView.layer.shadowColor = UIColor.black.cgColor
        loadingView.layer.shadowOpacity = 0.5
        loadingView.layer.shadowOffset = CGSize.zero
        loadingView.layer.shadowRadius = 5
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        beginParsing()
        configureMySession()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

   
    
    func showLoading() {
        loadingView.alpha = 0.0
        loadingView.isHidden = false
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.loadingView.alpha = 1.0
            
        }, completion: { finished in
        })
    }
    func hideLoading() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.loadingView.alpha = 0.0
        }, completion: { finished in
            self.loadingView.isHidden = true
        })
    }
    
    
    //PARSER ISH
    func beginParsing()
    {
        parser = XMLParser(contentsOf:(URL(string:"http://flaresoftware.com/scroller/songs.xml"))!)!
        parser.delegate = self
        
        allSongsArray.removeAll()
        songName = ""
        songComposer = ""
        songFileName = ""
        
        parser.parse()
        listTableView.reloadData()
        hideLoading()
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
            allSongsArray.append(Song(songName: songName, songComposer: songComposer, songFileName: songFileName))
        
            songName = ""
            songComposer = ""
            songFileName = ""
        }
    }
    //
    
    
    // MARK: TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredSongs.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! scrollerLibraryTableViewCell
        
        let song: Song = filteredSongs[indexPath.row]
        
        cell.titleLabel.text = song.songName
        cell.composerLabel.text = song.songComposer
        cell.activityIndicator.isHidden = true
        cell.accessoryType = UITableViewCellAccessoryType.none

        return cell
    }
    func filterContentForSearchText(searchText: String) {
        filteredSongs = allSongsArray.filter({( song : Song) -> Bool in
            let nameAndComposer = song.songName + song.songComposer
            return nameAndComposer.lowercased().contains(searchText.lowercased())
        })
        listTableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        thisIndex = indexPath.row
        startDownload()
    }
    
    func startDownload() {
        let cell = self.listTableView.cellForRow(at: IndexPath(row: thisIndex, section: 0)) as! scrollerLibraryTableViewCell
        cell.activityIndicator.isHidden = false
        let url: URL = URL(string: "http://flaresoftware.com/scroller/songs/\(filteredSongs[thisIndex].songFileName)")!
        downloadURLTask = getSongsSession.downloadTask(with: url)
        downloadURLTask.resume()
        isDownloading = true
    }
    func configureMySession() {
        let config = URLSessionConfiguration.background(withIdentifier: "com.flaresoftware.scroller.SearchSession")
        getSongsSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        makeFileName(location: location)
    }
    var copyNumber: Int = 1
    func makeFileName(location: URL) {
        let urlpath = URL(fileURLWithPath: getDocumentsDirectory().appendingPathComponent("Scroller\(copyNumber).xml"))
        
        if FileManager.default.fileExists(atPath: urlpath.path) {
            print("File Already Exists! Renaming file...")
            copyNumber += 1
            makeFileName(location: location)
        } else {
            copyNumber = 1
            saveFile(location: location, destination: urlpath)
        }
    }
    func saveFile(location: URL, destination: URL) {
        do {
            try FileManager.default.moveItem(at: location, to: destination)
            print("\(destination)")
        } catch {
            print("An error occurred while moving file to destination url")
        }
        DispatchQueue.main.async(){
            self.listTableView.reloadData()
            let cell = self.listTableView.cellForRow(at: IndexPath(row: self.thisIndex, section: 0)) as! scrollerLibraryTableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
    
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
