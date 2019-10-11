//
//  setlistsViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 9/16/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class SetlistsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {
  
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!

    var setlistArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.listTableView.delegate = self
        self.listTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchForNewFiles()
        findSetlistDirContents()
    }
    
    
    func searchForNewFiles() {
        let fileChecker = checkForSongs()
        if fileChecker.areThereMissingSongs() == true {
            let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newSongMetadata") as! newSongMetadataViewController
            secondViewController.missingSongs = fileChecker.missingSongs
            present(secondViewController, animated: true, completion: nil)
        }
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
            listTableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if listTableView.isEditing == true {
            listTableView.setEditing(false, animated: false)
            editButton.title = "edit"
            listTableView.reloadData()
        } else {
            listTableView.setEditing(true, animated: false)
            editButton.title = "done"
            listTableView.reloadData()
        }
    }
    @IBAction func addButtonPressed(_ sender: Any) {
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
                self.addSetlist(setlistName: textField.text!)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func addSetlist(setlistName: String) {
        let setlistContents = "<Metadata></Metadata>"
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let destPathForXML = NSURL(fileURLWithPath: destPath).appendingPathComponent("setlists/\(setlistName).xml")
        do {
            try setlistContents.write(toFile: (destPathForXML?.path)!, atomically: true, encoding: String.Encoding.utf8)
            findSetlistDirContents()
            print("New Setlist: \(setlistName)")
        } catch {
            print("\n Could not create setlist file\n")
        }
    }
    
    
    // MARK: TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setlistArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetlistCell", for: indexPath) as! SetlistTableViewCell
        
        cell.setlistTitle.text = setlistArray[indexPath.row]
        cell.setlistTitle.tag = indexPath.row
        cell.setlistTitle.addTarget(self, action: #selector(hideKeyboard(sender:)), for: .editingDidEndOnExit)
        cell.setlistTitle.addTarget(self, action: #selector(editingField(sender:)), for: .editingDidBegin)
        cell.setlistTitle.addTarget(self, action: #selector(editingField(sender:)), for: .editingChanged)
        cell.setlistTitle.addTarget(self, action: #selector(doneEditingField(sender:)), for: .editingDidEnd)

        if listTableView.isEditing == true {
            cell.setlistTitle.isEnabled = true
        } else {
            cell.setlistTitle.isEnabled = false
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            listTableView.isUserInteractionEnabled = false

            let setlistTitle = setlistArray[indexPath.row]
            
            let fileManager = FileManager.default
            let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let docsURL = dirPaths[0]
            let metaDir = docsURL.appendingPathComponent("setlists/\(setlistTitle).xml").path
            
            do {
                try fileManager.removeItem(atPath: metaDir)
            } catch let error as NSError {
                print("Could not delete \(setlistTitle).xml setlist: \(error)")
            }
            
            setlistArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        listTableView.isUserInteractionEnabled = true
        listTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func hideKeyboard(sender: UITextField) {
        sender.resignFirstResponder()
    }
    func editingField(sender: UITextField) {
        var extraOffset: Int = 0
        if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
            extraOffset = 20
        }
        let offset: CGPoint = CGPoint(x: 0, y: 85*sender.tag - extraOffset - Int((self.navigationController?.navigationBar.frame.height)!))
        listTableView.setContentOffset(offset, animated: true)
    }
    func doneEditingField(sender: UITextField) {
        let cell = listTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! SetlistTableViewCell
        var newFileName: String = ""
        
        if cell.setlistTitle.text == "" {
            newFileName = ""
        } else {
            newFileName = cell.setlistTitle.text!
        }
        
        let urlpath = URL(fileURLWithPath: getDocumentsDirectory().appendingPathComponent("setlists/\(newFileName).xml"))
        
        if FileManager.default.fileExists(atPath: urlpath.path) && setlistArray[sender.tag] != newFileName {
            let cell = listTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! SetlistTableViewCell
            cell.setlistTitle.text = setlistArray[sender.tag]
            let alert = UIAlertController(title: "Setlists Already Exists", message: "Another setlist with this name already exists.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            do {
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let documentDirectory = URL(fileURLWithPath: path)
                let originPath = documentDirectory.appendingPathComponent("setlists/\(setlistArray[sender.tag]).xml")
                let destinationPath = documentDirectory.appendingPathComponent("setlists/\(newFileName).xml")
                try FileManager.default.moveItem(at: originPath, to: destinationPath)
                setlistArray[sender.tag] = newFileName
            } catch {
                print(error)
            }
        }
    }
    
    
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    
    //SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSongsInSetlists" {
            if let indexPath = listTableView.indexPathForSelectedRow {
                let controller = (segue.destination) as! SetlistsSongsViewController
                controller.thisSetlistName = setlistArray[indexPath.row]
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
