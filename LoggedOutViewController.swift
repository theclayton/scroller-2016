//
//  LoggedOutViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 1/3/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class LoggedOutViewController: UIViewController {

    @IBOutlet weak var singinButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        singinButton.layer.cornerRadius = 10
        
        createButton.layer.cornerRadius = 10
    }

    
    @IBAction func noThanksPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToMySongsFromWelcome", sender: self)
        
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set("Scroller Guest", forKey: "username")
        UserDefaults.standard.set("nobody", forKey: "name")
        UserDefaults.standard.set(false, forKey: "confirmcode")
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
