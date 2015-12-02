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
    let tabBarAppearance = UITabBar.appearance()
    let tabBarItemAppearance = UITabBarItem.appearance()
    let navBarAppearance = UINavigationBar.appearance()
    lazy var coreDataStack = CoreDataStack()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
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
        
        if userDefaults.objectForKey("hasLaunchedOnce") == nil {
            userDefaults.setBool(true, forKey: "hasLaunchedOnce")
            window.rootViewController = storyboard.instantiateViewControllerWithIdentifier("InitialImport") as! InitialImportVC
        } else {
            window.rootViewController = storyboard.instantiateViewControllerWithIdentifier("MainView") as UIViewController
        }
    }
    
    func styleNavigationBar() {
        navBarAppearance.barTintColor = UIColor.birthdayColor()
        navBarAppearance.tintColor = UIColor.whiteColor()
        navBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 23)!]
    }
    
    func styleTabBar() {
        tabBarAppearance.barTintColor = UIColor.birthdayColor()
        tabBarAppearance.tintColor = UIColor.whiteColor()
        tabBarItemAppearance.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
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

