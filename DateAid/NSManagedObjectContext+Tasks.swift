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
    
    func tryFetch(_ request: NSFetchRequest<Date>? = nil, completion: ([Date?], Error?) -> ()) {
        let request = request ?? NSFetchRequest(entityName: "Date")
        
        do {
            let events = try fetch(request)
            completion(events, nil)
        } catch {
            completion([], error)
        }
    }

    func trySave(completion: (Bool, Error?) -> ()) {
        guard hasChanges else { return }
        do {
            try save()
            completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
}
