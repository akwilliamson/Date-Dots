//
//  CalendarManager.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/1/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

class DatePickerManager {
    
    // MARK: Private Properties
    
    private var activeDays: [Int] = []
    
    private var activeYears: [Int] = {
        let thisYear = Calendar.current.component(.year, from: Date())
        let years = (1920...thisYear).map { $0 }
        return years
    }()
    
    // MARK: Public Properties
    
    var selectedDay = 15
    
    var selectedMonth = 5 {
        didSet {
            setPickerDays()
        }
    }
    
    var selectedYear = 1970 {
        didSet {
            setPickerDays()
        }
    }
    
    var selectedYearIndex: Int {
        activeYears.firstIndex(of: selectedYear) ?? 50
    }
    
    var days: [String] {
        return activeDays.map { String($0) }
    }
    
    var months: [String] {
        return DateFormatter().monthSymbols
    }
    
    var years: [String] {
        return activeYears.map { String($0) }
    }
    
    // MARK: Initialization
    
    init(date: Date?) {
        if let day = date?.day {
            setDay(day)
        }
        if let month = date?.month {
            setMonth(month)
        }
        if let year = date?.year {
            let yearIndex = activeYears.firstIndex(of: year) ?? selectedYearIndex
            setYear(yearIndex)
        }
        
        setPickerDays()
    }
    
    // MARK: Public Methods
    
    func setDay(_ day: Int) {
        selectedDay = day
    }
    
    func setMonth(_ month: Int) {
        selectedMonth = month
    }
    
    func setYear(_ yearIndex: Int) {
        selectedYear = activeYears[yearIndex]
    }
    
    // MARK: Private Methods
    
    private func setPickerDays() {
        switch selectedMonth {
        case 0, 2, 4, 6, 7, 9, 11:
            activeDays = Array(1...31)
        case 3, 5, 8, 10:
            activeDays = Array(1...30)
        case 1:
            let isLeapYear = selectedYear % 4 == 0
            activeDays = isLeapYear ? Array(1...29) : Array(1...28)
        default:
            return
        }
    }
}
