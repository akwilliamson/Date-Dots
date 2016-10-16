//
//  DatesDataSource.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/15/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation
import CoreData

struct DatesDataSource {
    
    let moc = CoreDataStack().managedObjectContext
    
    mutating func fetch(dateType: DateType?, sort descriptors: [String]? = ["equalizedDate", "name"]) -> [Date?] {
        
        let request: NSFetchRequest<Date> = NSFetchRequest(entityName: "Date")
        
        if let type = dateType?.lowercased {
            request.predicate = NSPredicate(format: "type = %@", type)
        }
        
        var sortDescriptors: [NSSortDescriptor] = []
        descriptors?.forEach { sortDescriptors.append(NSSortDescriptor(key: $0, ascending: true)) }
        request.sortDescriptors = sortDescriptors
        
        return moc.tryFetch(request)
    }
    
    func delete(_ date: Date) {
        moc.delete(date)
        moc.trySave()
    }
}
