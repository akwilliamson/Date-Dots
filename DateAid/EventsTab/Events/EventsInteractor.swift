//
//  EventsInteractor.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import CoreData

protocol EventsInteractorInputting: class {
    
    func fetchEvents() -> Void
    func getEvents() -> Void
    func getEvents(containing searchText: String) -> Void
    func delete(_ event: Event)
}

enum EventsInteractorError: Error {
    case deleteFailed
    case fetchFailed
}

class EventsInteractor: CoreDataInteractable {
    
    weak var presenter: EventsInteractorOutputting?
    
    // A flag indicating if dates should be sorted by how far away they are from today.
    private var sortByToday = true
    
    private var events: [Event] = []
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
            let events: [Event] = try moc.fetch([sortDescriptorDate, sortDescriptorName])
            self.events = customSorted(events)
            presenter?.eventsFetched(self.events)
        } catch {
            presenter?.eventsFetchedFailed(EventsInteractorError.fetchFailed)
        }
    }
    
    func getEvents() {
        presenter?.eventsFetched(events)
    }
    
    func getEvents(containing searchText: String) {
        if searchText.isEmpty {
            presenter?.eventsFetched(events)
        } else {
            let filteredEvents = events.filter { (event) -> Bool in
                guard let eventName = event.name else { return false }
                return eventName.contains(searchText)
            }

            presenter?.eventsFetched(filteredEvents)
        }
    }
    
    func delete(_ event: Event) {
        moc.delete(event)
        do {
            try moc.save()
            presenter?.eventDeleted(event)
        } catch {
            presenter?.eventDeleteFailed(EventsInteractorError.deleteFailed)
        }
    }
    
    // MARK: Private Helpers
    
    private func customSorted(_ events: [Event]) -> [Event] {
        if sortByToday {
            let today = Foundation.Date().formatted("MM/dd")
            
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
}
