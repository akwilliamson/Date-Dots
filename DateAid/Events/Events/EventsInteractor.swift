//
//  EventsInteractor.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import CoreData

protocol EventsInteractorInputting: AnyObject {
    
    func fetchEvents()
    func getEvents()
    func getEvents(containing searchText: String) -> Void
    func delete(_ event: Event)
    func cancelReminder(for id: String)
}

enum EventsInteractorError: Error {
    case deleteFailed
    case fetchFailed
}

class EventsInteractor {
    
    // MARK: VIPER
    
    weak var presenter: EventsInteractorOutputting?
    
    // MARK: Properties
    
    private var sortByToday = true
    
    private var events: [Event] = []
    
    private var notificationManager = NotificationManager()
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
        do {
            events = try CoreDataManager.fetch()
            migrateOldEvents {
                self.presenter?.eventsFetched(self.events)
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
                return event.givenName.contains(searchText) || event.familyName.contains(searchText)
            }

            presenter?.eventsFetched(filteredEvents)
        }
    }
    
    func delete(_ event: Event) {
        do {
            try CoreDataManager.delete(object: event)
        } catch {
            presenter?.eventDeleteFailed(EventsInteractorError.deleteFailed)
        }
    }
    
    func cancelReminder(for id: String) {
        notificationManager.removeNotification(with: id)
    }
}

// MARK: Pseudo-migration to reset event names for old app events

extension EventsInteractor {
    
    // Old events don't have a given/family name, so set those values to eventually delete the old properties.
    func migrateOldEvents(completion: @escaping () -> Void) {
        events.forEach { event in
            if event.abbreviatedName.isEmpty {
                do {
                    try CoreDataManager.delete(object: event)
                } catch {
                    print("error: \(error.localizedDescription)")
                }
            }
        }
        
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
            try CoreDataManager.save()
            completion()
        } catch {
            completion()
        }
    }
}
