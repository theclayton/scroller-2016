//
//  ByDificultyViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 8/1/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class ByDificultyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate  {
    
    //PARSER ISH
    var parser: XMLParser!
    var element: String = ""
    var endElement: String = ""
    
    var setlistSongArray = [Song]()
    var setlistTitlesArray = [String]()
    var songsInSetlistArray = [Int]()
    var numberOfSongsInSetlist: Int = 0
    var setlistTitle: String = ""
    
    var songName: String = ""
    var songComposer: String = ""
    var songFileName: String = ""
    var songID: String = ""
    
    var setlistXMLString: String = ""
    //
    var setlistDescriptionArray = [String]()
    var setlistDescription: String = ""
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var internetRequiredLabel: UILabel!
    
    // MARK: ViewDidLoad
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        beginParsing()
        listTableView.isUserInteractionEnabled = true
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
    
    
    func beginParsing()
    {
        let language = Locale.current.languageCode
        if language == "es" || language == "es-MX" { //ESPAÑOL
            parser = XMLParser(contentsOf:(URL(string:"http://flaresoftware.com/scroller/es/listasPorDificultad.xml"))!)!
        } else {
            parser = XMLParser(contentsOf:(URL(string:"http://flaresoftware.com/scroller/en/setlistsByDificulty.xml"))!)!
        }
        
        setlistTitlesArray = []
        parser.delegate = self
        parser.parse()
        listTableView.reloadData()
        hideLoading()
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual("Title") {
            setlistTitle.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        if element.isEqual("Description") {
            setlistDescription.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        if element.isEqual("Name") {
            songName.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        if element.isEqual("Composer") {
            songComposer.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        if element.isEqual("FileName") {
            songFileName.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        if element.isEqual("SongID") {
            songID.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        endElement = elementName
        
        if (endElement == "Song") {
            setlistSongArray.append(Song(songName: songName, songComposer: songComposer, songFileName: songFileName))
            numberOfSongsInSetlist += 1
            songName = ""
            songComposer = ""
            songFileName = ""
            songID = ""
        }
        if (endElement == "Setlist") {
            songsInSetlistArray.append(Int(numberOfSongsInSetlist))
            setlistTitlesArray.append(setlistTitle)
            setlistDescriptionArray.append(setlistDescription)
            setlistTitle = ""
            setlistDescription = ""
        }
        
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setlistTitlesArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetlistCell", for: indexPath) as! discoveryCell
        
        cell.setlistTitle.text = setlistTitlesArray[indexPath.row]
        cell.setlistDescriptionLabel.text = setlistDescriptionArray[indexPath.row]
        
        
        let language = Locale.current.languageCode
        if language == "es" || language == "es-MX" { //ESPAÑOL
            if let url  = URL(string: "http://flaresoftware.com/scroller/es/listas/setlistBDImg\((indexPath as NSIndexPath).row).png"),
                let data = try? Data(contentsOf: url)
            {
                cell.setlistImage.image = UIImage(data: data)
            }
        } else {
            if let url  = URL(string: "http://flaresoftware.com/scroller/en/setlists/setlistBDImg\((indexPath as NSIndexPath).row).png"),
                let data = try? Data(contentsOf: url)
            {
                cell.setlistImage.image = UIImage(data: data)
            }
        }
        
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
        refreshControl.addTarget(self, action: #selector(ByDificultyViewController.handleRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    func handleRefresh(refreshControl: UIRefreshControl) {
        beginParsing()
        refreshControl.endRefreshing()
    }
    
    //Deleting
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DshowSetlistBD" {
            if let indexPath = listTableView.indexPathForSelectedRow {
                let controller = (segue.destination) as! ByDificultySetList
                var songsStart: Int
                var songsEnd: Int
                
                if indexPath.row <= 0 {
                    songsStart = 0
                    if songsInSetlistArray[indexPath.row] >= 1 {
                        songsEnd = songsInSetlistArray[indexPath.row] - 1
                    } else {
                        songsEnd = 0
                    }
                } else {
                    songsStart = songsInSetlistArray[indexPath.row - 1]
                    songsEnd = songsInSetlistArray[indexPath.row] - 1
                }
                
                controller.setlistName = setlistTitlesArray[(indexPath as NSIndexPath).row]
                if songsEnd >= 1 {
                    controller.ThisSetlistArray.append(contentsOf: setlistSongArray[songsStart...songsEnd])
                } else {
                    controller.ThisSetlistArray = []
                }
                listTableView.isUserInteractionEnabled = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
