//
//  CoreDataStack.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/30/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    // MARK: Constants
    
    private enum Constant {
        enum String {
            static let database = "DateAid"
        }
    }
    
    // MARK: Static Instance
    
    static let shared: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: Constant.String.database)
        
        let flagsDescription = NSPersistentStoreDescription(url: databaseURL)
        let storeDescription = NSPersistentStoreDescription(url: databaseURL)
        
        flagsDescription.shouldInferMappingModelAutomatically = true
        flagsDescription.shouldMigrateStoreAutomatically = true
        
        container.persistentStoreDescriptions = [flagsDescription, storeDescription]
        
        return container
    }()
    
    static private let databaseURL: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[urls.count-1]
        return documentsDirectory.appendingPathComponent(Constant.String.database)
    }()
    
    // MARK: Public Properties
    
    static func fetch<T: NSManagedObject>() throws -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        
        do {
            return try shared.viewContext.fetch(request) as [T]
        } catch {
            throw error
        }
    }
    
    static func delete<T: NSManagedObject>(object: T) throws {
        shared.viewContext.delete(object)
        
        do {
            try shared.viewContext.save()
        } catch {
            throw error
        }
    }
    
    static func save() throws {
        guard shared.viewContext.hasChanges else { return }
        
        do {
            try shared.viewContext.save()
        } catch {
            throw error
        }
    }
}
