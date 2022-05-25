//
//  AppDelegate.swift
//  Date Dots
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData
import Flurry_iOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, Routing {
    
    var window: UIWindow?
    
    var child: Routing?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        CoreDataManager.shared.loadPersistentStores { storeDescription, error in
            self.child = RouteManager.shared.router(for: .eventsNavigation, parent: self)
            self.child?.present()
        }
        
        startFlurryAnalytics()

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
    
    private func startFlurryAnalytics() {
        
        Flurry.startSession(
            apiKey: "ZRGQSS9NYG66WPJY5J6P",
            sessionBuilder: FlurrySessionBuilder.init()
                .build(crashReportingEnabled: true)
                .build(appVersion: "2.1.0")
                .build(logLevel: .all)
        )
    }
}
