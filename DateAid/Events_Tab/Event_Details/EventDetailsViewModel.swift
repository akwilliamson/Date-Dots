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
    
    private let calendar = Calendar.current
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
        guard let eventDate = event.date else { return "?" }
        let numberOfYears = nextEventAgeTurning(on: eventDate)
        
        switch event.eventType {
        case .birthday: return "\(numberOfYears)"
        default:        return "#\(numberOfYears)"
        }
    }

    var countdownLabelText: String {
        guard let eventDate = event.date else { return "?" }
        let numberOfDays = nextEventDaysLeft(until: eventDate)
        
        switch numberOfDays {
        case 0:  return "Today"
        case 1:  return "\(numberOfDays)\nday"
        default: return "\(numberOfDays)\ndays"
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
    
    // MARK: Private Methods
    
    private func nextEventAgeTurning(on eventDate: Foundation.Date) -> Int {
        let dateToday  = calendar.startOfDay(for: Foundation.Date())
        let components = calendar.dateComponents([.day, .month], from: eventDate)
        let nextEvent  = calendar.nextDate(after: dateToday, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)!
        let numOfYears = calendar.dateComponents([.year], from: eventDate, to: nextEvent)
        
        return numOfYears.year ?? 0
    }
    
    private func nextEventDaysLeft(until eventDate: Foundation.Date) -> Int {
        let dateToday  = calendar.startOfDay(for: Foundation.Date())
        let components = calendar.dateComponents([.day, .month], from: eventDate)
        let nextEvent  = calendar.nextDate(after: dateToday, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)!
        let numOfDays  = calendar.dateComponents([.day], from: dateToday, to: nextEvent)

        return numOfDays.day ?? 0
    }
}
