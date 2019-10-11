//
//  GetSongsViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 9/23/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class GetSongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, URLSessionDownloadDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
   
    var getSongsSession: URLSession!
    var downloadURLTask: URLSessionDownloadTask!
    var activityindicatorIsHidden: Bool = true
    var isDownloading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        searchForNewFiles()
        configureMySession()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
        getSongsSession.invalidateAndCancel()
    }
    
    func searchForNewFiles() {
        let fileChecker = checkForSongs()
        if fileChecker.areThereMissingSongs() == true {
            let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newSongMetadata") as! newSongMetadataViewController
            secondViewController.missingSongs = fileChecker.missingSongs
            present(secondViewController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "downloadURLCell", for: indexPath) as! downloadURLTableViewCell
            cell.URLTextField.addTarget(self, action: #selector(hideKeyboard(sender:)), for: .editingDidEndOnExit)
            cell.URLTextField.addTarget(self, action: #selector(cancelDownload(sender:)), for: .editingChanged)
            cell.downloadIndicator.isHidden = activityindicatorIsHidden
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "instructionsCell", for: indexPath) as! importInstructionsTableViewCell
            
            if indexPath.row == 1 {
                cell.titleText.text = "The Scroller Library"
                cell.subtitleText.text = "Free high quality Music .XML Files."
                cell.iconImage.image = UIImage(named: "ScrollerIconSmall.png")
                cell.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
            } else if indexPath.row == 2 {
                cell.titleText.text = "List of Music .XML Websites"
                cell.subtitleText.text = "A list of the most popular Music .XML Websites"
                cell.iconImage.image = UIImage(named: "BulletListIcon.png")
            } else if indexPath.row == 3 {
                cell.titleText.text = "iTunes"
                cell.subtitleText.text = "From your desktop, drag and drop your Music .XML files into Scroller through iTunes."
                cell.iconImage.image = UIImage(named: "getSongsiTunesIcon.png")
            } else if indexPath.row == 4 {
                cell.titleText.text = "Other Apps"
                cell.subtitleText.text = "Import Music .XML files from other apps."
                cell.iconImage.image = UIImage(named: "otherAppsIcon.png")
            } else if indexPath.row == 5 {
                cell.titleText.text = "Mail, Messages, etc."
                cell.subtitleText.text = "Get Music .XML files shared to you by others."
                cell.iconImage.image = UIImage(named: "convoBubbleIcon.png")
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 130
        } else if indexPath.row == 1 {
            return 75
        } else {
            return 66
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scrollerLibrary") as! UITabBarController
            present(vc, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "ListOfSites", sender: self)
        } else if indexPath.row == 3 {
            self.performSegue(withIdentifier: "iTunesTutorial", sender: self)
        } else if indexPath.row == 4 {
            self.performSegue(withIdentifier: "OtherAppsTutorial", sender: self)
        } else if indexPath.row == 5 {
            self.performSegue(withIdentifier: "MailMessageTutorial", sender: self)
        }
    }
    func hideKeyboard(sender: UITextField) {
        sender.resignFirstResponder()
        downloadIsh()
    }
    
    // MARK: URL DOWNLOAD
    
    @IBAction func downloadURLPressed(_ sender: Any) {
       downloadIsh()
    }
    func downloadIsh() {
        let cell = listTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! downloadURLTableViewCell
        
        if cell.URLTextField.text != "" {
            cell.URLTextField.resignFirstResponder()
            cell.URLDownloadButton.isEnabled = false
            cell.downloadIndicator.isHidden = false
            activityindicatorIsHidden = false

            if isValidURL(url: cell.URLTextField.text!) {
                startDownload(songURL: cell.URLTextField.text!)
            } else {
                alertInvalidURL()
            }
        }
    }
    func startDownload(songURL: String) {
        let url: URL = URL(string: songURL)!
        downloadURLTask = getSongsSession.downloadTask(with: url)
        downloadURLTask.resume()
        isDownloading = true
    }
    func configureMySession() {
        let config = URLSessionConfiguration.background(withIdentifier: "com.flaresoftware.scroller.getSongsSession")
        getSongsSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        makeFileName(location: location)
    }
    var copyNumber: Int = 1
    func makeFileName(location: URL) {
        let urlpath = URL(fileURLWithPath: getDocumentsDirectory().appendingPathComponent("download\(copyNumber).xml"))
        
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
            
            let cell = self.listTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! downloadURLTableViewCell
            cell.URLDownloadButton.isEnabled = true
            cell.downloadIndicator.isHidden = true
            cell.URLTextField.text = ""
            self.activityindicatorIsHidden = true
            self.listTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            self.cancelDownload(sender: cell.URLTextField)
            self.searchForNewFiles()
        }
    }
    
    
    func isValidURL(url: String) -> Bool {
        if UIApplication.shared.canOpenURL(URL(string: url)!) {
            return true
        } else {
            return false
        }
    }
    func alertInvalidURL() {
        let alertController = UIAlertController(title: "Invalid URL", message: "Please enter a valid URL to begin the download. Be sure that the URL contains 'http://' or 'https://'", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
        
        let cell = listTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! downloadURLTableViewCell
        cell.URLDownloadButton.isEnabled = true
        cell.downloadIndicator.isHidden = true
        activityindicatorIsHidden = true
    }
    func cancelDownload(sender: UITextField) {
        if isDownloading == true {
            isDownloading = false
            downloadURLTask.cancel()
            let cell = listTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! downloadURLTableViewCell
            cell.URLDownloadButton.isEnabled = true
            cell.downloadIndicator.isHidden = true
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
