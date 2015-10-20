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
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let tabBarAppearance = UITabBarItem.appearance()
    lazy var coreDataStack = CoreDataStack()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.setStatusBarStyle(.LightContent, animated: false)
        let localNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        application.registerUserNotificationSettings(localNotificationSettings)
        // Show the import contacts view on first launch only
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialImportVC = storyboard.instantiateViewControllerWithIdentifier("InitialImport") as! InitialImportVC
            initialImportVC.managedContext = coreDataStack.managedObjectContext
        let datesTableVC = storyboard.instantiateViewControllerWithIdentifier("MainView") as UIViewController
        if let window = self.window {
            if userDefaults.objectForKey("seenInitialView") == nil {
                userDefaults.setBool(true, forKey: "hasLaunchedOnce")
                window.rootViewController = initialImportVC
            } else {
                window.rootViewController = datesTableVC
            }
        }
        tabBarAppearance.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)

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

