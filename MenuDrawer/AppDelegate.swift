//
//  AppDelegate.swift
//  MenuDrawer
//
//  Created by Olivia Lim on 7/15/16.
//  Copyright © 2016 Olivia Lim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        setUpWindows()
        
        return true
    }
}

//MARK: - Windows -
extension AppDelegate {
    
    private func setUpWindows() {
        setUpMainWindow()
    }
    
    private func setUpMainWindow() {
        guard window == nil else {
            return
        }
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = NavigationController()
        window?.backgroundColor = .greenColor()
        window?.makeKeyAndVisible()
    }
    
    
    //this gets called NEVER
    func loadMainContent(controller: UIViewController) {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        guard let rootViewController = appDelegate?.window?.rootViewController as? MainController else {
            return
        }
        
        rootViewController.loadController(controller)
    }
    
}

