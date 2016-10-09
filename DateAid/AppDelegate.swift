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
    
    lazy var coreDataStack = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Flurry.startSession("GRKF26Q66DS5Z6ZCVZ3M")
        styleNavigationBar()
        styleTabBar()
        showInitialImportOnFirstLaunch()
        
        return true
    }
    
    func showInitialImportOnFirstLaunch() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if UserDefaults.standard.object(forKey: "hasLaunchedOnce") == nil {
            UserDefaults.standard.set(true, forKey: "hasLaunchedOnce")
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "InitialImport") as? InitialImportVC
        } else {
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "MainView") as UIViewController
        }
    }
    
    func styleNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor.birthday
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 23)!]
    }
    
    func styleTabBar() {
        UITabBar.appearance().barTintColor = UIColor.birthday
        UITabBar.appearance().tintColor = UIColor.white
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    // Persist data to disk when app enters background
    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.managedObjectContext.trySave()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    // Persist data to disk when app terminates
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.managedObjectContext.trySave()
    }
}

