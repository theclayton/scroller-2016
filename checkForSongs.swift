//
//  checkForSongs.swift
//  Scroller
//
//  Created by Clayton Ward on 1/30/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class checkForSongs: NSObject, XMLParserDelegate {
    
    //New Song Ish
    var songArray = [Song]()
    var fileArray = [String]()
    var missingSongs = [String]()
    var parser: XMLParser!
    var element: String = ""
    var endElement: String = ""
    var songName: String = ""
    var songComposer: String = ""
    var songFileName: String = ""
    
    func areThereMissingSongs() -> Bool {
        beginParsing()
        moveSongsFromInbox()
        findSongFileDirContents()
        missingSongs.removeAll()
        
        if fileArray.count > 0 {
            for fileIndex in 0..<fileArray.count {
                let thisFile = "\(fileArray[fileIndex])"
                var doesExist: Bool = false
                for song in 0..<songArray.count {
                    let existingSong: String = songArray[song].songFileName
                    if thisFile == existingSong {
                        doesExist = true
                    }
                }
                if doesExist == false {
                    missingSongs.append(fileArray[fileIndex])
                }
            }
        }
        
        if missingSongs.count > 0 {
            for index in 0..<missingSongs.count {
                let thisOne: String = (missingSongs[index] as NSString).pathExtension
                if thisOne == "mxl" {
                    let thisOneFilename = missingSongs[index]
                    let thisUnzipper = unzipper()
                    missingSongs[index] = thisUnzipper.unZipThis(fileName: thisOneFilename)
                }
            }

            return true
        } else {
            return false
        }
    }
    func findSongFileDirContents() {
        fileArray.removeAll()
        let dirPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsURL = dirPaths[0]
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: docsURL, includingPropertiesForKeys: nil, options: [])
            let xmlFiles = directoryContents.filter{ $0.pathExtension == "xml" || $0.pathExtension == "mxl" }
            let xmlFileNames = xmlFiles.map{ $0.lastPathComponent }
            fileArray.append(contentsOf: xmlFileNames)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
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
    func moveSongsFromInbox() {
        var inboxFilesArray = [String]()
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let destFolderPath = NSURL(fileURLWithPath: docDir).appendingPathComponent("Inbox")
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: destFolderPath!, includingPropertiesForKeys: nil, options: [])
            let xmlFiles = directoryContents.filter{ $0.pathExtension == "xml" || $0.pathExtension == "mxl" }
            let xmlFileNames = xmlFiles.map{ $0.lastPathComponent }
            inboxFilesArray.append(contentsOf: xmlFileNames)
            
            //MOVE FILES IF ANY FROM INBOX
            if inboxFilesArray.count > 0 {
                for i in 0..<inboxFilesArray.count {
                    let thisFile: String = inboxFilesArray[i]
                    
                    let rootPath = NSURL(fileURLWithPath: docDir).appendingPathComponent("Inbox/\(thisFile)")
                    let destPath = NSURL(fileURLWithPath: docDir).appendingPathComponent("\(thisFile)")
                    do{
                        try FileManager.default.moveItem(atPath: (rootPath?.path)!, toPath: (destPath?.path)!)
                    } catch {
                        print("\n Could not move file: \(thisFile)\n")
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
}
