//
//  MXLtoXML.swift
//  Scroller
//
//  Created by Clayton Ward on 3/20/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import Foundation
import SSZipArchive

class unzipper: NSObject {
    
    var changedFileName: String = ""
    
    func unZipThis(fileName: String) -> String {

        
        
        // 1. Find Available File Name
        changedFileName = "\((fileName as NSString).deletingPathExtension)"
        let endFileURL = URL(fileURLWithPath: getDocumentsDirectory().appendingPathComponent("\(changedFileName).xml"))
        
        if FileManager.default.fileExists(atPath: endFileURL.path) {
            makeFileName(location: (changedFileName as NSString).deletingPathExtension)
            print("\n\n \(changedFileName) \n\n")
        }
        
        
        
        // 2. Unzip mxl
        let resourcePath: String = getDocumentsDirectory().appendingPathComponent("\(changedFileName).mxl")
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let destFolderPath = NSURL(fileURLWithPath: destPath).appendingPathComponent((changedFileName as NSString).deletingPathExtension)
        
        SSZipArchive.unzipFile(atPath: resourcePath, toDestination: (destFolderPath?.path)!)
        print(destPath)
        
        
        
        
        // 3. Move .xml from folder to main directory
        var zippedXMLFileName: String = ""
        var zippedContentsArray = [String]()
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let zippedContentsPath = NSURL(fileURLWithPath: docDir).appendingPathComponent("\(changedFileName)")
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: zippedContentsPath!, includingPropertiesForKeys: nil, options: [])
            let xmlFiles = directoryContents.filter{ $0.pathExtension == "xml" }
            let xmlFileNames = xmlFiles.map{ $0.lastPathComponent }
            zippedContentsArray.append(contentsOf: xmlFileNames)
            if zippedContentsArray.count > 0 {
                zippedXMLFileName = zippedContentsArray[0]
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
        let MoveFromPath: String = getDocumentsDirectory().appendingPathComponent("\(changedFileName)/\(zippedXMLFileName)")
        let MoveDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent("\(changedFileName).xml")
        do {
            try FileManager.default.moveItem(atPath: MoveFromPath, toPath: (MoveDestPath?.path)!)
        } catch {
            print("Failed to move file")
        }
        
        
        // 4. Delete zip directory
        do {
            try FileManager.default.removeItem(at: destFolderPath!)
        } catch {
            print("Failed to remove file")
        }
        
        // 5. Delete original .MXL file
        do {
            try FileManager.default.removeItem(atPath: resourcePath)
        } catch {
            print("Failed to remove file")
        }
        
        
        return "\(changedFileName).xml"
    }
    
    var copyNumber: Int = 1
    func makeFileName(location: String) {
        let urlpath = URL(fileURLWithPath: getDocumentsDirectory().appendingPathComponent("\(location)\(copyNumber).xml"))
        
        if FileManager.default.fileExists(atPath: urlpath.path) {
            print("File Already Exists! Renaming file...")
            copyNumber += 1
            makeFileName(location: location)
        } else {
            let resourcePath: String = getDocumentsDirectory().appendingPathComponent("\(location).mxl")
            let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let destPathFile = NSURL(fileURLWithPath: destPath).appendingPathComponent("\(changedFileName)\(copyNumber).mxl")
            
            do {
                try FileManager.default.moveItem(atPath: resourcePath, toPath: (destPathFile?.path)!)
                changedFileName = "\(changedFileName)\(copyNumber)"
                copyNumber = 1
            } catch {
                print("Failed to change file name")
            }
        }
    }
    
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
}
