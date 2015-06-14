//
//  AppDelegate.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

/*
Next to do: Prevent saving duplicate dates to disc
*/

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let viewController = self.window!.rootViewController as! InitialImportVC
        viewController.managedContext = coreDataStack.managedObjectContext
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let rootController1 = storyboard.instantiateViewControllerWithIdentifier("InitialImport") as! UIViewController
//        let rootController2 = storyboard.instantiateViewControllerWithIdentifier("MainView") as! UIViewController
    
//        if NSUserDefaults.standardUserDefaults().objectForKey("seenInitialView") == nil {
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLaunchedOnce")
//            if let window = self.window {
//                self.window!.rootViewController = rootController1
//            }
//        } else {
//            if let window = self.window {
//                self.window!.rootViewController = rootController2
//            }
//        }
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

