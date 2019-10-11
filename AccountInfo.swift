//
//  AccountInfo.swift
//  Scroller
//
//  Created by Clayton Ward on 1/2/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import Foundation

class AccountInfo: NSObject {

    var userID: String?
    var name: String?
    var email: String?
    var accountType: String?
    var username: String?
    var password: String?
    var confirmcode: String?
    
    override init() {}
    
    init(userID: String, name: String, email: String, accountType: String, username: String, password: String, confirmcode: String) {
        self.userID = userID
        self.name = name
        self.email = email
        self.accountType = accountType
        self.username = username
        self.password = password
        self.confirmcode = confirmcode
    }
    
    override var description: String {
        return "\(userID!), \(name!), \(email!), \(accountType!), \(username!), \(password!), \(confirmcode!)"
    }
}
