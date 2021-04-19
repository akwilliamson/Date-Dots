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

    init(event: Event) {
        self.event = event
    }

    // MARK: Private Interface
    
    private let calendar = Calendar.current
    private let notificationManager = NotificationManager()
    private var toggledEvent = ToggledEvent.address
    
    // MARK: Public Interface
    
    public var event: Event
    
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
        return event.abvName
    }
    
    var dateLabelText: String {
        return event.date.formatted("MMM dd").replacingOccurrences(of: " ", with: "\n")
    }

    var ageLabelText: String {
        let numberOfYears = nextEventAgeTurning(on: event.date)
        
        switch event.eventType {
        case .birthday: return "\(numberOfYears)"
        default:        return "#\(numberOfYears)"
        }
    }

    var countdownLabelText: String {
        let numberOfDays = nextEventDaysLeft(until: event.date)
        
        switch numberOfDays {
        case 0:  return "Today"
        case 1:  return "\(numberOfDays)\nday"
        default: return "\(numberOfDays)\ndays"
        }
    }

    // MARK: Public Methods
    
    func updateEvent(_ event: Event) {
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
            eventName: event.abvName,
            eventType: event.eventType,
            eventDate: event.date,
            daysRemaining: nextEventDaysLeft(until: event.date)
        )
    }
    
    // MARK: Private Methods
    
    private func nextEventAgeTurning(on eventDate: Date) -> Int {
        let dateToday  = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day, .month], from: eventDate)
        let nextEvent  = calendar.nextDate(after: dateToday, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)!
        let numOfYears = calendar.dateComponents([.year], from: eventDate, to: nextEvent)
        
        return numOfYears.year ?? 0
    }
    
    private func nextEventDaysLeft(until eventDate: Date) -> Int {
        let dateToday  = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day, .month], from: eventDate)
        let nextEvent  = calendar.nextDate(after: dateToday, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)!
        let numOfDays  = calendar.dateComponents([.day], from: dateToday, to: nextEvent)

        return numOfDays.day ?? 0
    }
}
