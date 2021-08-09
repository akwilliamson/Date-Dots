//
//  CalendarManager.swift
//  DateAid
//
//  Created by Aaron Williamson on 8/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

class CalendarManager {

    func daysBetween(triggerDate: Date, eventDate: Date) -> Int {
        let normalizedDates = normalizeDates(triggerDate: triggerDate, eventDate: eventDate)
        
        guard let start = Calendar.current.ordinality(of: .day, in: .era, for: normalizedDates.triggerDate) else { return 0 }
        guard let end = Calendar.current.ordinality(of: .day, in: .era, for: normalizedDates.eventDate) else { return 0 }
        
        
        return end - start
    }
    
    // Sets the trigger date year to the event date year
    private func normalizeDates(triggerDate: Date, eventDate: Date) -> (triggerDate: Date, eventDate: Date) {
        
        var eventDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: eventDate)
        // Year
        eventDateComponents.year = Calendar.current.dateComponents([.year], from: triggerDate).year
        // Hour
        eventDateComponents.hour = Calendar.current.dateComponents([.hour], from: triggerDate).hour
        // Minute
        eventDateComponents.minute = Calendar.current.dateComponents([.minute], from: triggerDate).minute
        // Second
        eventDateComponents.second = Calendar.current.dateComponents([.second], from: triggerDate).second
        
        let normalizedEventDate = Calendar.current.date(from: eventDateComponents)!
        
        return (triggerDate, normalizedEventDate)
    }
}
