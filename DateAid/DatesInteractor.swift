//
//  DatesInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import CoreData

class DatesInteractor {
    
    weak var presenter: DatesInteractorPresenterProtocol!
    
    required init(presenter: DatesInteractorPresenterProtocol) {
        self.presenter = presenter
    }
    
    let moc = CoreDataStack().managedObjectContext
}

extension DatesInteractor: DatesPresenterInteractorProtocol {
    
    func dateFilterCategories() {
        
        let categories = [
            FilterDateType.all.pluralValue,
            FilterDateType.birthday.pluralValue,
            FilterDateType.anniversary.pluralValue,
            FilterDateType.holiday.pluralValue
        ]
        
        presenter.styleSegmentedControl(with: categories)
    }

    func fetchDates(for type: DateType?, sort descriptors: [String]?) {
        
        let request: NSFetchRequest<Date> = NSFetchRequest(entityName: "Date")
        
        if let type = type?.lowercased {
            request.predicate = NSPredicate(format: "type = %@", type)
        }
        
        if let descriptors = descriptors {
            request.sortDescriptors = descriptors.map { return NSSortDescriptor(key: $0, ascending: true) }
        }
        
        let dates = moc.tryFetch(request)
        
        presenter.fetched(dates)
    }
    
    func delete(_ date: Date) {
        moc.delete(date)
        moc.trySave()
    }
}
