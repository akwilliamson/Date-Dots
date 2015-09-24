//
//  AppDelegate.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let creamColor = UIColor(red: 255/255.0, green: 245/255.0, blue: 185/255.0, alpha: 1)
    lazy var coreDataStack = CoreDataStack()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Show the import contacts view on first launch only
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootController1 = storyboard.instantiateViewControllerWithIdentifier("InitialImport") as! InitialImportVC
        rootController1.managedContext = coreDataStack.managedObjectContext
        let rootController2 = storyboard.instantiateViewControllerWithIdentifier("MainView") as UIViewController
    
        if NSUserDefaults.standardUserDefaults().objectForKey("seenInitialView") == nil {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLaunchedOnce")
            if let window = self.window {
                window.rootViewController = rootController1
            }
        } else {
            if let window = self.window {
                window.rootViewController = rootController2
            }
        }
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: creamColor], forState:.Normal)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    // Persist data to disk when app enters background
    func applicationDidEnterBackground(application: UIApplication) {
        coreDataStack.saveContext()
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    // Persist data to disk when app terminates
    func applicationWillTerminate(application: UIApplication) {
        coreDataStack.saveContext()
    }
}

