//
//  EventDetailsViewModel.swift
//  Date Dots
//
//  Created by Aaron Williamson on 4/25/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class EventDetailsViewModel {

    enum ToggledEvent {
        case address
        case reminder
    }

    // MARK: Initialization

    init(event: Date) {
        self.event = event
    }

    // MARK: Private Interface
    
    private let notificationManager = NotificationManager()
    private var toggledEvent = ToggledEvent.address
    
    // MARK: Public Interface
    
    public var event: Date
    
    public var eventColor: UIColor {
        return event.eventType.color
    }
    
    public var eventType: EventType {
        return event.eventType
    }
    
    public var address: Address? {
        return event.address
    }
    
    var titleText: String {
        return event.abbreviatedName ?? "Event"
    }
    
    var dateLabelText: String {
        guard let date = event.date else { return "?" }
        return date.formatted("MMM dd").replacingOccurrences(of: " ", with: "\n")
    }

    var ageLabelText: String {
        guard let date = event.date, let nextEventNumber = date.ageTurning else { return "?" }
        return event.eventType == .birthday ? "\(nextEventNumber)" : "#\(nextEventNumber)"
    }

    var countdownLabelText: String {
        guard let date = event.date, let daysUntil = date.daysUntil else { return "?" }
        switch daysUntil {
        case 0:  return "Today"
        case 1:  return "\(daysUntil)\nday"
        default: return "\(daysUntil)\ndays"
        }
    }

    // MARK: Public Methods
    
    func updateEvent(_ event: Date) {
        self.event = event
    }

    func didToggleEvent(_ toggledEvent: ToggledEvent) {
        self.toggledEvent = toggledEvent
    }
    
    func colorForToggle(toggledEvent: ToggledEvent) -> UIColor {
        return self.toggledEvent == toggledEvent ? eventColor : .compatibleLabel
    }
    
    func getNotification(completion: @escaping (UNNotificationRequest?) -> Void) {
        notificationManager.notification(with: event.objectIDString) { foundNotification in
            completion(foundNotification)
        }
    }
    
    /// Creates the details needed to instantiate an `EventReminderViewController`.
    func generateEventReminderDetails() -> EventReminderDetails {
        return EventReminderDetails(
            identifier: event.objectIDString,
            eventName: event.abbreviatedName ?? event.name!,
            eventType: event.eventType,
            eventDate: event.date!
        )
    }
}
