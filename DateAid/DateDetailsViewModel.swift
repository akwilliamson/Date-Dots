//
//  DateDetailsViewModel.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/25/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

class DateDetailsViewModel {

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

    // MARK: Address

    func textForAddressLabel(for event: Date) -> String {
        guard let street = event.address?.street, let region = event.address?.region else {
            return "No Address"
        }

        return "\(street)\n\(region)"
    }

    // MARK: Reminders

    func textForReminderLabel(for daysPrior: Int?, hourOfDay: Int?) -> String {
        guard let daysPrior = daysPrior, let hourOfDay = hourOfDay  else {
            return "Reminder\nNot Set"
        }

        var text: String

        switch daysPrior {
        case 0:  text = "Day of\n"
        case 1:  text = "\(daysPrior) day before\n"
        default: text = "\(daysPrior) days before\n"
        }
        
        switch hourOfDay {
        case 0:      text += "at midnight"
        case 1...11: text += "at \(hourOfDay)am"
        case 12:     text += "at noon"
        default:     text += "at \(hourOfDay - 12)pm"
        }
        
        return text
    }
}
