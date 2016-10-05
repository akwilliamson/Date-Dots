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
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.documentDirectoryUrl.appendingPathComponent("DateAid")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: false]
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return psc
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        
        if let modelUrl = Bundle.main.url(forResource: "DateAid", withExtension: "momd"),
           let mom = NSManagedObjectModel(contentsOf: modelUrl) {
            return mom
        } else {
            return NSManagedObjectModel()
        }
    }()
    
    private lazy var documentDirectoryUrl: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
}
