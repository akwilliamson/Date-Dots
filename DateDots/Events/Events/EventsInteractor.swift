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
        Dispatch.main.async {
            do {
                self.events = try CoreDataManager.fetch()
                self.presenter?.eventsFetched(self.events)
            } catch {
                self.presenter?.eventsFetchedFailed(EventsInteractorError.fetchFailed)
            }
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
