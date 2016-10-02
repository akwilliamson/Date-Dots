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
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("DateAid")
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: false]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch  {
            print("Error adding persistent store.")
        }
        return persistentStoreCoordinator
    }()
    
    fileprivate lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "DateAid", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do { try managedObjectContext.save()
            } catch let error as NSError {
                print("Could not save: \(error), \(error.userInfo)")
            }
        }
    }
}
