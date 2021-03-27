//
//  EventListInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import CoreData

protocol EventListInteractorInputting: class {
    
    func fetchEvents()
}

class EventListInteractor: CoreDataInteractable {
    
    // MARK: Properties
    
    weak var presenter: EventListInteractorOutputting?
    
    // MARK: Constants
    
    private struct Constant {
        struct SortDescriptor {
            static let name = "name"
        }
    }
    
    func fetchEvents() {
        // Sort events by name
        let sortDescriptor = NSSortDescriptor(key: Constant.SortDescriptor.name, ascending: true)
        
        do {
            let events: [Event] = try moc.fetch([sortDescriptor])
            presenter?.eventsFetched(events)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension EventListInteractor: EventListInteractorInputting {
    
}
