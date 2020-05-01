//
//  ReminderViewViewModel.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/29/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import Foundation

struct ReminderViewViewModel {
    
    var eventID: URL

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
