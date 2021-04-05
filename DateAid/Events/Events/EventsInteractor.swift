//
//  EventsInteractor.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import CoreData

protocol EventsInteractorInputting: class {
    
    func fetchEvents()
    func getEvents()
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
            migrateOldEvents {
                presenter?.eventsFetched(self.events)
            }
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
                return event.name.contains(searchText)
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
            let today = Date().formatted("MM/dd")
            
            let sortedEvents = events.sorted { event1, event2 -> Bool in
                let event1 = event1.equalizedDate
                let event2 = event2.equalizedDate
                
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

// MARK: Pseudo-migration to reset event names for old app events

extension EventsInteractor {
    
    // Old events don't have a given/family name, so create them to eventually delete the old properties.
    func migrateOldEvents(completion: () -> Void) {
        events = events.map { event -> Event in
            if event.givenName.isEmpty {
                let nameComponents = event.name.components(separatedBy: " ")
                if nameComponents.count == 2 {
                    event.givenName = nameComponents.first ?? "No Name"
                    event.familyName = nameComponents.last ?? String()
                } else {
                    event.givenName = nameComponents.first ?? "No Name"
                    event.familyName = String()
                }
            }
            return event
        }
        
        do {
            try moc.save()
            completion()
        } catch {
            print("wtf \(error.localizedDescription))")
            completion()
        }
    }
}
