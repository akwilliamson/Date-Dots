//
//  EventsInteractor.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import CoreData
import UserNotifications

protocol EventsInteractorInputting: AnyObject {
    
    func fetchEvents()
    func getEvents()
    func getEvents(containing searchText: String) -> Void
    func fetchReminders()
    func findReminder(for event: Event)
}

enum EventsInteractorError: Error {
    case fetchFailed
}

class EventsInteractor {
    
    // MARK: VIPER
    
    weak var presenter: EventsInteractorOutputting?
    
    // MARK: Properties
    
    private let notificationManager = NotificationManager()
    
    private var events: [Event] = []
    private var reminders: [UNNotificationRequest] = []
}

extension EventsInteractor: EventsInteractorInputting {

    func fetchEvents() {
        do {
            events = try CoreDataManager.fetch()
            migrateEvents {
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
    
    func fetchReminders() {
        notificationManager.retrieveNotifications { [weak self] reminders in
            guard let strongSelf = self else { return }
            
            strongSelf.reminders = reminders
            strongSelf.presenter?.remindersFetched()
        }
    }
    
    func findReminder(for event: Event) {
        if let foundReminder = reminders.filter({ $0.identifier == event.id }).first {
            Dispatch.main {
                self.presenter?.reminderFound(for: event, reminder: foundReminder)
            }
        } else {
            Dispatch.main {
                self.presenter?.reminderNotFound(for: event)
            }
        }
    }
}

// MARK: Pseudo-migration to reset event names for old app events

extension EventsInteractor {
    
    // Old events don't have a given/family name, so set those values to eventually delete the old properties.
    func migrateEvents(completion: @escaping () -> Void) {
        events.forEach { event in
            if event.abbreviatedName.isEmpty {
                do {
                    try CoreDataManager.delete(object: event)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        let reminderIDs = reminders.map { $0.identifier }
        
        events = events.map { event -> Event in
            
            if event.givenName.isEmpty {
                let nameComponents = event.name.components(separatedBy: " ")
                
                event.givenName = nameComponents.first ?? "No Name"
                
                if nameComponents.count == 2 {
                    event.familyName = nameComponents.last ?? String()
                } else {
                    event.familyName = String()
                }
            }
            
            if event.type == "other" {
                event.type = "custom"
            }
            
            if event.type == "holiday" {
                event.type = "custom"
            }

            event.hasReminder = reminderIDs.contains(event.id)
            
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
