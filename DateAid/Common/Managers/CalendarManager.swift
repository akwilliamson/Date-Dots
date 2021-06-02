//
//  CalendarManager.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/1/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

class CalendarManager {
    
    // MARK: Properties
    
    private let initialYear: Int
    
    private let days28 = Array(1...28)
    private let days29 = Array(1...29)
    private let days30 = Array(1...30)
    private let days31 = Array(1...31)
    
    private let months = DateFormatter().monthSymbols ?? []
    
    private lazy var years: [Int] = {
        let thisYear = Calendar.current.component(.year, from: Date())
        let years = (initialYear...thisYear).map { $0 }
        return years
    }()
    
    // MARK: Initialization
    
    init(initialYear: Int) {
        self.initialYear = initialYear
    }
    
    // MARK: Public Interface
    
    public func formattedDaysFor(month: Int, year: Int) -> [String] {
        switch month {
        case 0, 2, 4, 6, 7, 9, 11:
            return days31.map { String($0) }
        case 3, 5, 8, 10:
            return days30.map { String($0) }
        case 1:
            let isLeapYear = years[year] % 4 == 0
            return isLeapYear ? days29.map { String($0) } : days28.map { String($0) }
        default:
            return []
        }
    }
    
    public func formattedMonths() -> [String] {
        return DateFormatter().monthSymbols
    }
    
    public func formattedYears() -> [String] {
        return years.map { String($0) }
    }
    
    public func getDate(monthIndex: Int, dayIndex: Int, yearIndex: Int) -> Date {
        let dateComponents = DateComponents(year: years[yearIndex], month: monthIndex+1, day: dayIndex+1)
        
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
}
