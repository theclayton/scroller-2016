//
//  ListOfSitesViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 3/23/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class ListOfSitesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {

    //PARSER ISH
    var parser: XMLParser!
    var element: String = ""
    var endElement: String = ""
    
    var siteName: String = ""
    var siteDescription: String = ""
    var siteURL: String = ""
    
    var websiteListArray = [siteInfo]()

    @IBOutlet weak var listTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.listTableView.delegate = self
        self.listTableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        beginParsing()
    }
    
    // PARSER
    func beginParsing()
    {
        parser = XMLParser(contentsOf:(URL(string:"http://flaresoftware.com/scroller/mxlsites.xml"))!)!
        websiteListArray.removeAll()
        parser.delegate = self
        parser.parse()
        listTableView.reloadData()
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual("name") {
            siteName.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        if element.isEqual("description") {
            siteDescription.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
        if element.isEqual("url") {
            siteURL.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        endElement = elementName
        
        if (endElement == "site") {
            websiteListArray.append(siteInfo(name: siteName, description: siteDescription, siteURL: siteURL))
            siteName = ""
            siteDescription = ""
            siteURL = ""
        }
    }
    
    
    // TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websiteListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "siteCell", for: indexPath)
        
        let thisSite: siteInfo = websiteListArray[indexPath.row]
        
        cell.textLabel?.text = thisSite.name
        cell.detailTextLabel?.text = thisSite.description
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let URLtoOpen: String = websiteListArray[indexPath.row].siteURL
        
        UIApplication.shared.openURL(NSURL(string: URLtoOpen)! as URL)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
class siteInfo {
    var name: String
    var description: String
    var siteURL: String
    
    init (name: String, description: String, siteURL: String) {
        self.name = name
        self.description = description
        self.siteURL = siteURL
    }
}
