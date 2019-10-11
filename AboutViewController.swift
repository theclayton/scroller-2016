//
//  AboutViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 9/29/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    
    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openPolicy(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "http://flaresoftware.com/privacy.html")! as URL)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
