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
    
    /// A generic fetch request that returns an array of the given object.
    func fetch<T: NSManagedObject>(_ sortDescriptors: [NSSortDescriptor] = []) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.sortDescriptors = sortDescriptors

        return try fetch(fetchRequest)
    }
}
