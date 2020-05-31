//
//  EventsInteractor.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import CoreData

enum EventsInteractorError: Error {
    case deleteFailed
    case fetchFailed
}

class EventsInteractor: CoreDataInteractable {
    
    weak var presenter: EventsInteractorOutputting?
    
    // A flag indicating if dates should be sorted by how far away they are from today.
    private var sortByToday = true
}

extension EventsInteractor: EventsInteractorInputting {
    
    private struct Constant {
        struct SortDescriptor {
            static let date = "equalizedDate"
            static let name = "name"
        }
        struct Formatter {
            private static let date = "MM/dd"
        }
    }

    func fetchEvents() {
        // Sort events by date
        let sortDescriptorDate = NSSortDescriptor(key: Constant.SortDescriptor.date, ascending: true)
        // Then sort events by name
        let sortDescriptorName = NSSortDescriptor(key: Constant.SortDescriptor.name, ascending: true)
        
        do {
            let events: [Date] = try moc.fetch([sortDescriptorDate, sortDescriptorName])
            let sortedEvents = customSorted(events)
            presenter?.eventsFetched(sortedEvents)
        } catch {
            presenter?.eventsFetchedFailed(EventsInteractorError.fetchFailed)
        }
    }
    
    private func customSorted(_ events: [Date]) -> [Date] {
        if sortByToday {
            let today = Foundation.Date.now.formatted("MM/dd")
            
            let sortedEvents = events.sorted { event1, event2 -> Bool in
                guard
                    let event1 = event1.equalizedDate,
                    let event2 = event2.equalizedDate
                else {
                    return false
                }
                
                if (event1 >= today && event2 < today) {
                    return (event1 > event2)
                } else {
                    return (event1 < event2)
                }
            }
            return sortedEvents
        } else {
            return events
        }
    }
    
    func delete(_ event: Date) {
        moc.delete(event)
        do {
            try moc.save()
            presenter?.eventDeleted(event)
        } catch {
            presenter?.eventDeleteFailed(EventsInteractorError.deleteFailed)
        }
    }
}
