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
class AppDelegate: UIResponder, UIApplicationDelegate, Routing {
    
    var window: UIWindow?
    
    var child: Routing?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        CoreDataManager.shared.loadPersistentStores { storeDescription, error in
            if let error = error {
                // TODO: Show an error screen
                print(error.localizedDescription)
            } else {
                self.showInitialView()
            }
        }
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Persist data to disk when app enters background
        do { try CoreDataManager.save() } catch {}
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Persist data to disk when app terminates
        do { try CoreDataManager.save() } catch {}
    }
    
    // MARK: Private Methods
    
    private func showInitialView() {
        let hasLaunchedOnce = UserDefaults.standard.bool(forKey: "hasLaunchedOnce")
        
        if hasLaunchedOnce {
            child = RouteManager.shared.router(for: .eventsNavigation, parent: self)
            child?.present()
        } else {
            // TODO: On first launch, navigation to initial import screen
            UserDefaults.standard.set(true, forKey: "hasLaunchedOnce")
            // presentChild(route: .import)
        }
    }
}
