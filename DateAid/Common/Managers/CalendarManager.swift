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
        let normalizedDates = normalizeYear(triggerDate: triggerDate, eventDate: eventDate)
        
        guard let start = Calendar.current.ordinality(of: .day, in: .era, for: normalizedDates.triggerDate) else { return 0 }
        guard let end = Calendar.current.ordinality(of: .day, in: .era, for: normalizedDates.eventDate) else { return 0 }
        
        
        return end - start
    }
    
    // Sets the trigger date year to the event date year
    private func normalizeYear(triggerDate: Date, eventDate: Date) -> (triggerDate: Date, eventDate: Date) {
        
        var eventDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: eventDate)
        eventDateComponents.year = Calendar.current.dateComponents([.year], from: triggerDate).year
        
        let normalizedEventDate = Calendar.current.date(from: eventDateComponents)!
        
        return (triggerDate, normalizedEventDate)
    }
}
