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
    
    // MARK: Constants
    
    private enum Constant {
        static let hasLaunchedOnce = "hasLaunchedOnce"
    }
    
    private var appWireframe: AppDelegateWireframe?
    private let coreDataStack = CoreDataStack()
    
    var window: UIWindow?
    
    /// The main, shared managed object context throughout the app.
    public lazy var moc: NSManagedObjectContext = {
        return coreDataStack.managedObjectContext
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appWireframe = AppDelegateWireframe()

        showInitialView()
        
        return true
    }
    
    private func showInitialView() {
        let hasLaunchedOnce = UserDefaults.standard.bool(forKey: Constant.hasLaunchedOnce)
        
        if hasLaunchedOnce == false {
            UserDefaults.standard.set(true, forKey: Constant.hasLaunchedOnce)
            appWireframe?.presenter.showImport(in: window)
        } else {
            appWireframe?.presenter.showEvents(in: window)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Persist data to disk when app enters background
        do { try coreDataStack.managedObjectContext.save() } catch {}
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Persist data to disk when app terminates
        do { try coreDataStack.managedObjectContext.save() } catch {}
    }
}
