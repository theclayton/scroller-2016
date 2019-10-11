//
//  newSongMetadataViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 1/28/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class newSongMetadataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {
   
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var navBarTitle: UINavigationItem!

    //PARSER ISH
    var parser: XMLParser!
    var element: String = ""
    var endElement: String = ""
   
    var workTitle: String = ""
    var creator: String = ""
    var creditWords: String = ""
    var songName: String = ""
    var songComposer: String = ""
    var songFileName: String = ""
    
    var thisMissingFile: String = ""
    var meteadataXMLString: String = ""
    
    var missingSongs = [String]()
    var fileInfoArray = [newSong]()
    var songArray = [Song]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        if missingSongs.count == 1 {
            navBarTitle.title = "Add \(missingSongs.count) New Song"
        } else {
            navBarTitle.title = "Add \(missingSongs.count) New Songs"
        }
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        print(missingSongs)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for i in 0..<missingSongs.count {
            thisMissingFile = missingSongs[i]
            
            beginParsing(filename: thisMissingFile)
            fileInfoArray.append(newSong(songName: workTitle, songComposer: creator, textFound: creditWords, songFileName: thisMissingFile))
            workTitle = ""
            creator = ""
            creditWords = ""
            
            if i >= missingSongs.count-1 {
                listTableView.reloadData()
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        beginParsing(filename: "metadata/metadata.xml")
        addToSongArray()
        rewriteXML()
        saveMetadata()
    }

    func addToSongArray() {
        for i in 0..<fileInfoArray.count {
            var songTitle: String = fileInfoArray[i].songName
            var songComposer: String = fileInfoArray[i].songComposer
            if songTitle == "" {
                songTitle = fileInfoArray[i].songFileName
            }
            if songComposer == "" {
                songComposer = "Unknown Composer"
            }
            
            let thisSong: Song = Song(songName: songTitle, songComposer: songComposer, songFileName: fileInfoArray[i].songFileName)
            songArray.append(thisSong)
        }
    }
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
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("\n Could not create setlist file\n")
        }
    }
    
    
    //PARSER ISH
    func beginParsing(filename: String) {
        let urlpath: String = getDocumentsDirectory().appendingPathComponent(filename)
        let url: URL = URL(fileURLWithPath: urlpath)
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        
        workTitle = ""
        creator = ""
        creditWords = ""
        
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual("work-title") {
            workTitle.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        if element.isEqual("creator") {
            creator.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        if element.isEqual("credit-words") {
            creditWords.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            creditWords.append(". ")
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
        return fileInfoArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newSongTableCell", for: indexPath) as! newSongCell
        
        let song: newSong = fileInfoArray[indexPath.row]
        
        cell.fileNumber.text = "\(indexPath.row+1)"
        cell.titleField.text = song.songName
        cell.composerField.text = song.songComposer
        cell.fileName.text = song.songFileName
        cell.TextFoundLabel.text = song.textFound
        
        cell.titleField.tag = indexPath.row
        cell.titleField.addTarget(self, action: #selector(editingTitleField(sender:)), for: .editingChanged)
        cell.titleField.addTarget(self, action: #selector(editingBegan(sender:)), for: .editingDidBegin)
        cell.titleField.addTarget(self, action: #selector(hideKeyboard(sender:)), for: .editingDidEndOnExit)
        
        cell.composerField.tag = indexPath.row
        cell.composerField.addTarget(self, action: #selector(editingComposerField(sender:)), for: .editingChanged)
        cell.composerField.addTarget(self, action: #selector(editingBegan(sender:)), for: .editingDidBegin)
        cell.composerField.addTarget(self, action: #selector(hideKeyboard(sender:)), for: .editingDidEndOnExit)

        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 182
    }
    
    
    func editingBegan(sender: UITextField) {
        let offset: CGPoint = CGPoint(x: 0, y: 182*sender.tag)
        listTableView.setContentOffset(offset, animated: true)
    }
    func editingTitleField(sender: UITextField) {
        let offset: CGPoint = CGPoint(x: 0, y: 182*sender.tag)
        listTableView.setContentOffset(offset, animated: true)
        let cell = listTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! newSongCell
        
        fileInfoArray[sender.tag] = newSong(songName: cell.titleField.text!, songComposer: fileInfoArray[sender.tag].songComposer, textFound: fileInfoArray[sender.tag].textFound, songFileName: fileInfoArray[sender.tag].songFileName)
    }
    func editingComposerField(sender: UITextField) {
        let offset: CGPoint = CGPoint(x: 0, y: 182*sender.tag)
        listTableView.setContentOffset(offset, animated: true)
        let cell = listTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! newSongCell
        
        fileInfoArray[sender.tag] = newSong(songName: fileInfoArray[sender.tag].songName, songComposer: cell.composerField.text!, textFound: fileInfoArray[sender.tag].textFound, songFileName: fileInfoArray[sender.tag].songFileName)
    }
    func hideKeyboard(sender: UITextField) {
        sender.resignFirstResponder()
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
