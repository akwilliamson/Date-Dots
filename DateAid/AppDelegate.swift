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
    let userDefaults = UserDefaults.standard
    let tabBarAppearance = UITabBar.appearance()
    let tabBarItemAppearance = UITabBarItem.appearance()
    let navBarAppearance = UINavigationBar.appearance()
    lazy var coreDataStack = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        startAnalyticSessions()
        styleNavigationBar()
        styleTabBar()
        showInitialImportOnFirstLaunch()
        
        return true
    }
    
    func startAnalyticSessions() {
        Flurry.startSession("GRKF26Q66DS5Z6ZCVZ3M")
        AppAnalytics.initWithAppKey("SsKD7Ojo2Fh7qjVoCqSCHLWIReKCItvZ")
    }
    
    func showInitialImportOnFirstLaunch() {
        guard let window = self.window else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if userDefaults.object(forKey: "hasLaunchedOnce") == nil {
            userDefaults.set(true, forKey: "hasLaunchedOnce")
            window.rootViewController = storyboard.instantiateViewController(withIdentifier: "InitialImport") as! InitialImportVC
        } else {
            window.rootViewController = storyboard.instantiateViewController(withIdentifier: "MainView") as UIViewController
        }
    }
    
    func styleNavigationBar() {
        navBarAppearance.barTintColor = UIColor.birthdayColor()
        navBarAppearance.tintColor = UIColor.white
        navBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 23)!]
    }
    
    func styleTabBar() {
        tabBarAppearance.barTintColor = UIColor.birthdayColor()
        tabBarAppearance.tintColor = UIColor.white
        tabBarItemAppearance.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: UIControlState())
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    // Persist data to disk when app enters background
    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    // Persist data to disk when app terminates
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
}

