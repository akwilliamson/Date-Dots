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
    var appWireframe: AppDelegateWireframe?
    
    lazy var coreDataStack = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
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
        coreDataStack.managedObjectContext.trySave { _ in }
    }

    // Persist data to disk when app terminates
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.managedObjectContext.trySave { _ in }
    }
}

extension AppDelegate: AppDelegateOutputting {
    
    func initializeFlurry() {
        Flurry.startSession(Constant.Flurry.APIKey.value)
    }
}


