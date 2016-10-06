//
//  NSManagedObjectContext+Tasks.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/2/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {

    func trySave() {
        if self.hasChanges {
            do {
                try self.save()
            } catch let error {
                print("Could not save: \(error.localizedDescription)")
            }
        }
    }
    
    func tryFetch(_ request: NSFetchRequest<Date>? = nil) -> [Date?] {
        
        let request = request ?? NSFetchRequest(entityName: "Date")
        
        do {
            return try self.fetch(request)
        } catch let error {
            print("Could not fetch: \(error.localizedDescription)")
            return []
        }
    }
}
