//
//  DcomposersViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 7/21/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class DcomposersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    
    //PARSER ISH
    var parser: XMLParser!
    var element: String = ""
    var endElement: String = ""
    
    var allSongsArray = [Song]()
    var uniqueComposersArray:[String] = []
    
    var songName: String = ""
    var songComposer: String = ""
    var songFileName: String = ""
    //
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var internetRequiredLabel: UILabel!
    
    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = UIColor.scrollerDiscovery()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        tabBarController?.tabBar.barTintColor = UIColor.white
        (UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])).tintColor = UIColor.white
        tabBarController?.tabBar.tintColor = UIColor(red: 85.0/255.0, green: 170.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        
        self.listTableView.addSubview(self.refreshControl)
        
        loadingView.isHidden = false
        loadingView.layer.cornerRadius = 5
        loadingView.layer.shadowColor = UIColor.black.cgColor
        loadingView.layer.shadowOpacity = 0.5
        loadingView.layer.shadowOffset = CGSize.zero
        loadingView.layer.shadowRadius = 5
        
        internetRequiredLabel.alpha = 0.0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        beginParsing()
        listTableView.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    func uniqueComposers() {
        var fullComposerArray:[String] = []
        
        if allSongsArray.count >= 1 {
            for i in 0...allSongsArray.count-1 {
                let song: Song = allSongsArray[i]
                
                fullComposerArray.append(song.songComposer)
            }
            uniqueComposersArray = Array(Set(fullComposerArray))
        }
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
            self.internetRequiredLabel.alpha = 1.0
        }, completion: { finished in
            self.loadingView.isHidden = true
        })
    }
    
    //PARSER ISH
    func beginParsing()
    {
        parser = XMLParser(contentsOf:(URL(string:"http://flaresoftware.com/scroller/songs.xml"))!)!
        parser.delegate = self
        
        allSongsArray = []
        uniqueComposersArray = []
        songName = ""
        songComposer = ""
        songFileName = ""
        
        parser.parse()
        uniqueComposers()
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
        return uniqueComposersArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "composerCell", for: indexPath)
        uniqueComposersArray.sort(by: { $0 < $1 })
        cell.textLabel?.text = uniqueComposersArray[indexPath.row]
        
        return cell
    }
    
    //Refresh
    lazy var refreshControl: UIRefreshControl = {
        var refreshString: String = "Pull to refresh"
        let language = Locale.current.languageCode
        if language == "es" || language == "es-MX" { //ESPAÑOL
            refreshString = "Dezlisa para actualizar"
        } else {
            refreshString = "Pull to refresh"
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: refreshString)
        refreshControl.addTarget(self, action: #selector(DcomposersViewController.handleRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    func handleRefresh(refreshControl: UIRefreshControl) {
        beginParsing()
        refreshControl.endRefreshing()
    }
    
    //DELETING
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DshowSongsByComposer" {
            if let indexPath = listTableView.indexPathForSelectedRow {
                let controller = (segue.destination) as! DSongsByComposerViewController
                controller.composerName = uniqueComposersArray[indexPath.row]
                listTableView.isUserInteractionEnabled = false
                
                var thisComposerArray = [Song]()
                if allSongsArray.count >= 1 {
                    for i in 0...allSongsArray.count-1 {
                        let song: Song = allSongsArray[i]
                        
                        if song.songComposer == uniqueComposersArray[indexPath.row] {
                            thisComposerArray.append(song)
                        }
                        if i >= allSongsArray.count-1 {
                            controller.ThisSetlistArray.append(contentsOf: thisComposerArray)
                        }
                    }
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
