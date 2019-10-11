//
//  DiscoverSetlistViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 7/30/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class DiscoverSetlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, URLSessionDownloadDelegate  {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var getSongsSession: URLSession!
    var downloadURLTask: URLSessionDownloadTask!
    var isDownloading: Bool = false
    var thisIndex: Int = 0
    var downloadNumber: Int = 0
    var downloadingArray = [Int]()
    
    var ThisSetlistArray = [Song]()
    
    var setlistName: String!
    var selectedSongIndex: IndexPath!
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = setlistName
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = UIColor.scrollerDiscovery()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        tabBarController?.tabBar.barTintColor = UIColor.white
        (UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])).tintColor = UIColor.white
        tabBarController?.tabBar.tintColor = UIColor(red: 50.0/255.0, green: 100.0/255.0, blue: 160.0/255.0, alpha: 1.0)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureMySession()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ThisSetlistArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! scrollerLibraryTableViewCell
        
        cell.titleLabel.text = ThisSetlistArray[(indexPath as NSIndexPath).row].songName
        cell.composerLabel.text = ThisSetlistArray[(indexPath as NSIndexPath).row].songComposer
        if downloadingArray.count > 0 {
            for i in 0..<downloadNumber {
                let thisSong: Int = downloadingArray[i]
                if thisSong == indexPath.row {
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                    cell.activityIndicator.isHidden = true
                }
            }
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        if downloadingArray.count > downloadNumber {
            for b in downloadNumber..<downloadingArray.count {
                let thisSong: Int = downloadingArray[b]
                if thisSong == indexPath.row {
                    cell.activityIndicator.isHidden = false
                }
            }
        } else {
            cell.activityIndicator.isHidden = true
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        thisIndex = indexPath.row
        startDownload()
    }
    
    func startDownload() {
        downloadingArray.append(thisIndex)
        let cell = self.listTableView.cellForRow(at: IndexPath(row: thisIndex, section: 0)) as! scrollerLibraryTableViewCell
        cell.activityIndicator.isHidden = false
        let url: URL = URL(string: "http://flaresoftware.com/scroller/songs/\(ThisSetlistArray[thisIndex].songFileName)")!
        downloadURLTask = getSongsSession.downloadTask(with: url)
        downloadURLTask.resume()
        isDownloading = true
    }
    func configureMySession() {
        let config = URLSessionConfiguration.background(withIdentifier: "com.flaresoftware.scroller.\(setlistName)Session")
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
            self.downloadNumber += 1
        }
    }
    
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
