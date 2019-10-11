//
//  selectSetlistViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 1/26/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class selectSetlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {
    
    @IBOutlet weak var setlistsTableView: UITableView!
 
    var setlistArray = [String]()
    var thisSong: Song = Song(songName: "", songComposer: "", songFileName: "")
    
    var parser: XMLParser!
    var element: String = ""
    var endElement: String = ""
   
    var songName: String = ""
    var songComposer: String = ""
    var songFileName: String = ""
    
    var setlistXMLString: String = ""
    var songArray = [Song]()
    var thisSetlistName: String = ""
    var thisSongName: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setlistsTableView.delegate = self
        self.setlistsTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        findSetlistDirContents()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func findSetlistDirContents() {
        setlistArray.removeAll()
        let dirPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsURL = dirPaths[0]
        let newDir = docsURL.appendingPathComponent("setlists")
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: newDir, includingPropertiesForKeys: nil, options: [])
            let xmlFiles = directoryContents.filter{ $0.pathExtension == "xml" }
            let xmlFileNames = xmlFiles.map{ $0.deletingPathExtension().lastPathComponent }
            setlistArray.append(contentsOf: xmlFileNames)
            setlistsTableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    func addSetlist(setlistName: String) {
        let setlistContents = "<Metadata></Metadata>"
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let destPathForXML = NSURL(fileURLWithPath: destPath).appendingPathComponent("setlists/\(setlistName).xml")
        do {
            try setlistContents.write(toFile: (destPathForXML?.path)!, atomically: true, encoding: String.Encoding.utf8)
            findSetlistDirContents()
            print("New Setlist: \(setlistName)")
            
            rewriteXML()
        } catch {
            print("\n Could not create setlist file\n")
        }
    }
    func rewriteXML() {
        beginParsing()
        
        setlistXMLString = "<Metadata>"
        setlistXMLString.append("<Song><Name>\(thisSong.songName)</Name><Composer>\(thisSong.songComposer)</Composer><FileName>\(thisSong.songFileName)</FileName></Song>")

        if songArray.count > 0 {
            for i in 0...songArray.count-1 {
                setlistXMLString.append("<Song><Name>\(songArray[i].songName)</Name><Composer>\(songArray[i].songComposer)</Composer><FileName>\(songArray[i].songFileName)</FileName></Song>")
                
                if i >= songArray.count-1 {
                    setlistXMLString.append("</Metadata>")
                    saveSetlists()
                }
            }
        } else {
            setlistXMLString.append("</Metadata>")
            saveSetlists()
        }
    }
    func saveSetlists() {
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let destPathForXML = NSURL(fileURLWithPath: destPath).appendingPathComponent("setlists/\(thisSetlistName).xml")
        do {
            try setlistXMLString.write(toFile: (destPathForXML?.path)!, atomically: true, encoding: String.Encoding.utf8)
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("\n Could not create setlist file\n")
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setlistArray.count+1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setlistCell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Create New Setlist +"
            cell.textLabel?.textColor = UIColor.gray
        } else {
            cell.textLabel?.text = setlistArray[indexPath.row-1]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alert = UIAlertController(title: "New Setlist", message: "Setlists help you to stay organized and access groups of songs quickly.", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Setlist Name"
                textField.autocapitalizationType = UITextAutocapitalizationType.words
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in }))
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
                let textField = alert.textFields![0]
                if textField.text == "" {
                } else {
                    self.thisSetlistName = textField.text!
                    self.addSetlist(setlistName: textField.text!)
                }
            }))
            self.present(alert, animated: true, completion: nil)
    
        } else if indexPath.row > 0 {
            thisSetlistName = setlistArray[indexPath.row-1]
            rewriteXML()
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
