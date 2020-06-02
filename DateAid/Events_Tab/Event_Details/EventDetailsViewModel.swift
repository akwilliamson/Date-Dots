//
//  EventDetailsViewModel.swift
//  Date Dots
//
//  Created by Aaron Williamson on 4/25/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class EventDetailsViewModel {

    /// The options for displaying extra information about an event.
    enum ToggledEvent {
        case address
        case reminder
    }

    // MARK: Properties
    
    private var toggledEvent = ToggledEvent.address
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
    
    // MARK: Initialization
    init(event: Date) {
        self.event = event
    }

    // MARK: Text Population
    
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

    // MARK: Actions
    
    public func updateEvent(_ event: Date) {
        self.event = event
    }

    public func didToggleEvent(_ toggledEvent: ToggledEvent) {
        self.toggledEvent = toggledEvent
    }
    
    public func colorForToggle(toggledEvent: ToggledEvent) -> UIColor {
        return self.toggledEvent == toggledEvent ? eventColor : .compatibleLabel
    }
}
