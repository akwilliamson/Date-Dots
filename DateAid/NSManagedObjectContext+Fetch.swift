//
//  NSManagedObjectContext+Tasks.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/2/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    enum Predicate {
        case name
    }
    
    /// A generic fetch request that returns an array of the object provided.
    func fetch<T: NSManagedObject>(_ sortDescriptors: [NSSortDescriptor] = []) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.sortDescriptors = sortDescriptors

        return try fetch(fetchRequest)
    }
    
    /// A fetch request that returns an array of the object provided, matching the predicate and text given.
    func fetch<T: NSManagedObject>(_ sortDescriptors: [NSSortDescriptor] = [], predicate: Predicate, text: String) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.sortDescriptors = sortDescriptors
        
        switch predicate {
        case .name:
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@", text)
        }

        return try fetch(fetchRequest)
    }
}
