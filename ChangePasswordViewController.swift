//
//  ChangePasswordViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 1/9/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var registerWebView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerWebView.scrollView.isScrollEnabled = false
        self.registerWebView.delegate = self
        
        if let url = URL(string: "http://flaresoftware.com/scroller/account/reset-pwd-req.php") {
            let request = URLRequest(url: url)
            registerWebView.loadRequest(request)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
