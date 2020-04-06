//
//  DatesInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import CoreData

class DatesInteractor {
    
    weak var presenter: DatesInteractorOutputting?
    
    let moc = CoreDataStack().managedObjectContext
}

extension DatesInteractor: DatesInteractorInputting {

    func fetch(_ dateType: String) {
        
        let request: NSFetchRequest<Date> = NSFetchRequest(entityName: "Date")
        
        if dateType != "all" {
            request.predicate = NSPredicate(format: "type = %@", dateType)
        }
        
        let sortByDate = NSSortDescriptor(key: "equalizedDate", ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortByDate, sortByName]

        let today = Foundation.Date().formatted("MM/dd")
        
        let dates = moc.tryFetch(request).sorted { (a, b) -> Bool in
            guard let aDate = a?.equalizedDate, let bDate = b?.equalizedDate else { return false }
            return aDate >= today && bDate < today ? aDate > bDate : aDate < bDate
        }.compactMap { $0 }
        
        presenter?.set(dates)
    }
    
    func delete(_ date: Date?, complete: (Bool) -> ()) {
        guard let date = date else { complete(false); return }
        moc.delete(date)
        moc.trySave { success in
            complete(success)
        }
    }
}
