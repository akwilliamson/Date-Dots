//
//  AppDelegate.swift
//  Date Dots
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private var appWireframe: AppDelegateWireframe?
    private let coreDataStack = CoreDataStack()
    
    /// The main, shared managed object context throughout the app.
    public lazy var moc: NSManagedObjectContext = {
        return coreDataStack.managedObjectContext
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appWireframe = AppDelegateWireframe(appDelegateOutputting: self)
        
        appWireframe?.presenter.setupApp()

        showInitialView()
        
        return true
    }
    
    private func showInitialView() {
        let key = Constant.UserDefaults.hasLaunchedOnce.value
        let userHasLaunchedAppOnce = UserDefaults.standard.value(forKey: key)
        
        if userHasLaunchedAppOnce == nil {
            UserDefaults.standard.setValue(true, forKey: key)
            appWireframe?.presenter.showInitialImport(in: window)
        } else {
            appWireframe?.presenter.showDatesTabBar(in: window)
        }
    }

    // Persist data to disk when app enters background
    func applicationDidEnterBackground(_ application: UIApplication) {
        do {
            try coreDataStack.managedObjectContext.save()
        } catch {
            
        }
    }

    // Persist data to disk when app terminates
    func applicationWillTerminate(_ application: UIApplication) {
        do {
            try coreDataStack.managedObjectContext.save()
        } catch {
           
        }
    }
}

// MARK: AppDelegateOutputting

extension AppDelegate: AppDelegateOutputting {
    
    func setTabBar(tintColor: UIColor) {
        UITabBar.appearance().tintColor = tintColor
    }
    
    func setTabBar(barTintColor: UIColor) {
        UITabBar.appearance().barTintColor = barTintColor
    }
}
