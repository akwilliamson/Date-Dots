//
//  CoreDataStack.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/30/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    // MARK: Static Instance
    
    static let shared: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DateAid")
        
        let flagsDescription = NSPersistentStoreDescription()
        flagsDescription.shouldInferMappingModelAutomatically = true
        flagsDescription.shouldMigrateStoreAutomatically = true

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[urls.count-1]
        let url = documentsDirectory.appendingPathComponent("DateAid")
        
        let storeDescription = NSPersistentStoreDescription(url: url)
        
        container.persistentStoreDescriptions = [flagsDescription, storeDescription]
        
        return container
    }()
    
    // MARK: Public Properties
    
    static func fetch<T: NSManagedObject>() throws -> [T] {
        let context = shared.viewContext
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))

        do {
            return try context.fetch(request) as [T]
        } catch {
            throw error
        }
    }
    
    static func delete<T: NSManagedObject>(object: T) throws {
        let context = shared.viewContext
        context.delete(object)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    static func save() throws {
        let context = shared.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }
        }
    }
}
