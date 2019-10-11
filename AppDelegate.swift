//
//  AppDelegate.swift
//  Scroller
//
//  Created by Clayton Ward on 7/20/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        invalidateScrollerTimer()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        invalidateScrollerTimer()
    }
    func applicationWillTerminate(_ application: UIApplication) {
        invalidateScrollerTimer()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    
    func invalidateScrollerTimer() {
        let scroller = ScrollerViewController()
        scroller.invalidateTimers()
    }
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if self.window?.rootViewController?.presentedViewController is ScrollerViewController {
            
            let scrollerController = self.window!.rootViewController!.presentedViewController as! ScrollerViewController
            
            if scrollerController.isPresented {
                return UIInterfaceOrientationMask.landscape;
            } else {
                return UIInterfaceOrientationMask.all;
            }
        } else {
            return UIInterfaceOrientationMask.all;
        }
        
    }
    
}
extension UIColor {
    static func scrollerGrey() -> UIColor {
        return UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1.0)
    }
    static func scrollerDiscovery() -> UIColor {
        return UIColor(red: 50.0/255.0, green: 100.0/255.0, blue: 160.0/255.0, alpha: 1.0)
    }
    static func scrollerLightBlue() -> UIColor {
        return UIColor(red: 0/255.0, green: 225/255.0, blue: 255/255.0, alpha: 1.0)
    }
    static func scrollerLightGrey() -> UIColor {
        return UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    }
}
