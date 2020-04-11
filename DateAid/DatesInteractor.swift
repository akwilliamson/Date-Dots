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
    
    private let moc = CoreDataStack().managedObjectContext
}

extension DatesInteractor: DatesInteractorInputting {

    public func fetchDotDates() {
        
        let request: NSFetchRequest<Date> = NSFetchRequest(entityName: "Date")
        
        let sortByDate = NSSortDescriptor(key: "equalizedDate", ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)

        request.sortDescriptors = [sortByDate, sortByName]

        let today = Foundation.Date().formatted("MM/dd")
        
        let dates = moc.tryFetch(request).sorted { date1, date2 -> Bool in
            guard let date1 = date1?.equalizedDate, let date2 = date2?.equalizedDate else { return false }
            return (date1 >= today && date2 < today) ? (date1 > date2) : (date1 < date2)
        }.compactMap { $0 }
        
        presenter?.set(dates)
    }
    
    public func delete(_ date: Date?, complete: (Bool) -> ()) {
        guard let date = date else { complete(false); return }
        moc.delete(date)
        moc.trySave { success in
            complete(success)
        }
    }
}
