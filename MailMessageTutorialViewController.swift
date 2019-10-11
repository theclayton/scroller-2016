//
//  MailMessageTutorialViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 3/23/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class MailMessageTutorialViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var suppliesWebView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.suppliesWebView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        if let url = URL(string: "http://flaresoftware.com/scroller/ios-help/mail-message.html") {
            let request = URLRequest(url: url)
            suppliesWebView.loadRequest(request)
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            UIApplication.shared.openURL(request.url!)
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
}
