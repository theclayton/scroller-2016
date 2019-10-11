//
//  MyAccountViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 1/9/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    var username: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        signOutButton.target = self
        signOutButton.action = #selector(signOutButtonPressed(sender:))
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let savedUsername = UserDefaults.standard.string(forKey: "username")
        username = savedUsername!
        listTableView.reloadData()
        searchForNewFiles()
    }
    func searchForNewFiles() {
        let fileChecker = checkForSongs()
        if fileChecker.areThereMissingSongs() == true {
            let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newSongMetadata") as! newSongMetadataViewController
            secondViewController.missingSongs = fileChecker.missingSongs
            present(secondViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loggedInAsCell", for: indexPath) as! loggedInAsTableViewCell
            cell.usernameText.text = username
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
            
            if indexPath.row == 1 {
                cell.textLabel?.text = "Change password"
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "About Scroller"
            } else if indexPath.row == 3 {
                cell.textLabel?.text = "Sign out"
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 90
        } else {
            return 55
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resetPassword") as! UINavigationController
            present(vc, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "aboutScroller") as! AboutViewController
            present(vc, animated: true, completion: nil)
        } else if indexPath.row == 3 {
            signOut()
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signOutButtonPressed(sender: UIBarButtonItem) {
        signOut()
    }
    func signOut() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        print("User logged out.")
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "loggedOut") as! LoggedOutViewController
        self.present(secondViewController, animated: true, completion: nil)
    }

}
