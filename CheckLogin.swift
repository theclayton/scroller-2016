//
//  checkLogin.swift
//  Scroller
//
//  Created by Clayton Ward on 1/2/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import Foundation

protocol CheckLoginProtocal: class {
    func itemsDownloaded(items: NSArray)
}


class CheckLogin: NSObject, URLSessionDataDelegate {
    
    weak var delegate: CheckLoginProtocal!
    
    var data : NSMutableData = NSMutableData()
    
    let urlPath: String = "http://flaresoftware.com/scroller/scroller-is-cool.php"
    
    
    func downloadItems() {
        
        let url: NSURL = NSURL(string: urlPath)!
        var session: URLSession!
        let configuration = URLSessionConfiguration.default
        
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: url as URL)
        
        task.resume()
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data as Data);
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("Failed to download data")
        }else {
            self.parseJSON()
        }
    }
    
    
    func parseJSON() {
        
        var jsonResultPrev: NSArray = NSArray()
        var jsonResult: NSMutableArray = NSMutableArray()
        
        do{
            jsonResultPrev = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            jsonResult = NSMutableArray(array: jsonResultPrev)
            
        } catch let error as NSError {
            print(error)
        }
        
        var jsonElement: NSDictionary = NSDictionary()
        let accounts: NSMutableArray = NSMutableArray()
        
        for i in 0..<jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let account = AccountInfo()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let userID = jsonElement["id_user"] as? String,
                let name = jsonElement["name"] as? String,
                let email = jsonElement["email"] as? String,
                let accountType = jsonElement["account_type"] as? String,
                let username = jsonElement["username"] as? String,
                let password = jsonElement["password"] as? String,
                let confirmcode = jsonElement["confirmcode"] as? String
            {
                account.userID = userID
                account.name = name
                account.email = email
                account.accountType = accountType
                account.username = username
                account.password = password
                account.confirmcode = confirmcode
            }
            
            accounts.add(account)
        }
        
        DispatchQueue.main.async { () -> Void in
            self.delegate.itemsDownloaded(items: accounts)
        }
    }
}
