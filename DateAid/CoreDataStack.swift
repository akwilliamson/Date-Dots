//
//  CoreDataStack.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/21/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    // These properties correspond to the stack components. Since they aren't set to anything, an initializer is needed
    let       managedObjectContext: NSManagedObjectContext
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    let         managedObjectModel: NSManagedObjectModel
    let            persistentStore: NSPersistentStore?
    
    // This initializer is responsible for configuring each individual component in this Core Data stack
    init() {
        
        // Load the managed object model from disk into a NSManagedObjectModel object
        let bundle = NSBundle.mainBundle()
        let modelURL = bundle.URLForResource("DateAid", withExtension: "momd")
        managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL!)!
        
        // Set the persistent store coordinator
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        // Set the managed object context and connect it to the persistent store coordinator
        managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        // Access a URL to the application's documents directory
        // The SQLite databased (simply a file) will be stored in this directory which is the recommended place to store user's data
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        let documentsURL = urls[0]
        
        // Create the persistent store through the persistent store coordinator method
        let storeURL = documentsURL.URLByAppendingPathComponent("DateAid")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true]
        var error: NSError? = nil
        
        do {
            // Provide a persistent store type, a new URL to persist to, and any extra options
            persistentStore = try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
        } catch let error1 as NSError {
            error = error1
            persistentStore = nil
        }
        
        if persistentStore == nil {
            print("Error adding persistent store: \(error)")
            abort()
        }
    }
    
    // A convenience method to save the stack's managed object context with error handling
    func saveContext() {
        var error: NSError? = nil
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error1 as NSError {
                error = error1
                print("Could not save: \(error), \(error?.userInfo)")
            }
        }
    }
}