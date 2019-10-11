//
//  LoginViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 1/2/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, CheckLoginProtocal {
    
    var feedItems: NSArray = NSArray()
    var selecedAccount: AccountInfo = AccountInfo()
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let checkLogin = CheckLogin()
        checkLogin.delegate = self
        checkLogin.downloadItems()
    }
    func itemsDownloaded(items: NSArray) {
        feedItems = items
      //  print(feedItems)
    }
    
    @IBAction func usernameTextFieldChanged(_ sender: Any) {
        if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            signInButton.isEnabled = false
        } else {
            signInButton.isEnabled = true
        }
    }
    @IBAction func passwordTextFieldChanged(_ sender: Any) {
        if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            signInButton.isEnabled = false
        } else {
            signInButton.isEnabled = true
        }
    }
    @IBAction func usernameEnterPressed(_ sender: Any) {
        self.passwordTextField.becomeFirstResponder()
    }
    @IBAction func passwordEnterPressed(_ sender: Any) {
        signInPressed()
    }
    @IBAction func signInButtonPressed(_ sender: Any) {
        signInPressed()
    }
    func signInPressed() {
        //check username/password match
        for i in 0...feedItems.count-1 {
            let thisAccount: AccountInfo = feedItems[i] as! AccountInfo
            if usernameTextField.text == thisAccount.username && passwordTextField.text == thisAccount.password {
                print("RIGHT")
                
                self.performSegue(withIdentifier: "unwindToMySongsFromLoggin", sender: self)
                
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.set(thisAccount.username, forKey: "username")
                UserDefaults.standard.set("\(thisAccount.name)", forKey: "name")
                
                if thisAccount.confirmcode == "done" {
                    UserDefaults.standard.set(true, forKey: "confirmcode")
                } else {
                    UserDefaults.standard.set(false, forKey: "confirmcode")
                }
                
            } else {
                ShowIncorrectAlert()
            }
        }
    }
    func ShowIncorrectAlert() {
        let alertController = UIAlertController(title: "Wrong", message: "Your username or password isn't correct.", preferredStyle: .alert)
        let addWrongAction = UIAlertAction(title: "OK", style: .default) { (_) in
            print("WRONG.")
        }
        alertController.addAction(addWrongAction)
        present(alertController, animated: true, completion: nil)
        }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
