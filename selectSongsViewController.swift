//
//  selectSongsViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 1/18/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class selectSongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {

    @IBOutlet weak var allSongsTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var parser: XMLParser!
    var element: String = ""
    var endElement: String = ""
    var allSongsArray = [Song]()
    var songName: String = ""
    var songComposer: String = ""
    var songFileName: String = ""
    var SongArray = [Song]()

    var thisSetlistName: String = ""
    var setlistXMLString: String = ""
    
    var meteadataXMLString: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.isEnabled = false
    
        self.allSongsTableView.delegate = self
        self.allSongsTableView.dataSource = self
        
        self.allSongsTableView.allowsMultipleSelectionDuringEditing = true
        self.allSongsTableView.setEditing(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        beginParsing()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        addSongs()
    }
    func addSongs() {
            addButton.isEnabled = false
            rewriteXML()
    }
    func rewriteXML() {
        let selectedSongs = allSongsTableView.indexPathsForSelectedRows

        if selectedSongs != nil {
            var songsToAddArray = [Song]()
            for s in 0...(selectedSongs?.count)!-1 {
                let selectedIndex: Int = selectedSongs![s].row
                songsToAddArray.append(allSongsArray[selectedIndex])
            }
            
            setlistXMLString = "<Metadata>"
            
            if songsToAddArray.count > 0 {
                for i in 0...songsToAddArray.count-1 {
                    setlistXMLString.append("<Song><Name>\(songsToAddArray[i].songName)</Name><Composer>\(songsToAddArray[i].songComposer)</Composer><FileName>\(songsToAddArray[i].songFileName)</FileName></Song>")
                    if i >= songsToAddArray.count-1 {
                        if SongArray.count > 0 {
                            for b in 0...SongArray.count-1 {
                                setlistXMLString.append("<Song><Name>\(SongArray[b].songName)</Name><Composer>\(SongArray[b].songComposer)</Composer><FileName>\(SongArray[b].songFileName)</FileName></Song>")
                            }
                        }
                        setlistXMLString.append("</Metadata>")
                        saveSetlists()
                        self.performSegue(withIdentifier: "unwindToSongs", sender: self)
                    }
                }
            } else {
                if SongArray.count > 0 {
                    for bb in 0...SongArray.count-1 {
                        setlistXMLString.append("<Song><Name>\(SongArray[bb].songName)</Name><Composer>\(SongArray[bb].songComposer)</Composer><FileName>\(SongArray[bb].songFileName)</FileName></Song>")
                    }
                }
                setlistXMLString.append("</Metadata>")
                saveSetlists()
                self.performSegue(withIdentifier: "unwindToSongs", sender: self)
            }
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


    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSongsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        
        let thisSong: Song = allSongsArray[indexPath.row]
        
        cell.textLabel?.text = thisSong.songName
        cell.detailTextLabel?.text = thisSong.songComposer
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addButton.isEnabled = true
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedSongs = allSongsTableView.indexPathsForSelectedRows
        
        if selectedSongs?.isEmpty == true {
            addButton.isEnabled = false
        }
    }
    
    
    
    
    
    func beginParsing()
    {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: String = paths[0] as String
        let urlpath: String = (documentsDirectory as NSString).appendingPathComponent("metadata/metadata.xml")
        let url:URL = URL(fileURLWithPath: urlpath)
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        
        allSongsArray.removeAll()
        songName = ""
        songComposer = ""
        songFileName = ""
        
        parser.parse()
        allSongsTableView.reloadData()
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
