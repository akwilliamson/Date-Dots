//
//  DateDetailsViewModel.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/25/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

class DateDetailsViewModel {

    /// The options for displaying extra information about an event.
    enum ToggledEvent {
        case address
        case reminder
    }

    // MARK: Properties
    
    var toggledEvent: ToggledEvent = .address

    // MARK: Details

    func textForDateLabel(for event: Date) -> String {
        guard let readableDate = event.date?.formatted("MMM dd") else { return String() }
        return readableDate.replacingOccurrences(of: " ", with: "\n")
    }
    
    func textForAgeLabel(for event: Date) -> String {
        if let age = event.date?.ageTurning {
            return event.dateType == .birthday ? "\(age)" : "#\(age)"
        } else {
            return "?"
        }
    }
    
    func textForCountdownLabel(for event: Date) -> String {
        guard let daysUntil = event.date?.daysUntil else {
            return String()
        }
        
        switch daysUntil {
        case 0:  return "Today"
        case 1:  return "\(daysUntil)\nday"
        default: return "\(daysUntil)\ndays"
        }
    }

    // MARK: Actions

    func didToggleEvent(_ toggledEvent: ToggledEvent) {
        self.toggledEvent = toggledEvent
    }
}
