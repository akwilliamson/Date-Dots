//
//  EventCreationPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/25/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

protocol EventCreationEventHandling: AnyObject {
    
    func viewDidLoad()
    
    func didSelectEventType(eventType: EventType)
    func didToggleYearPicker(isOn: Bool)
    func didChangeFirstName(text: String)
    func didChangeLastName(text: String)
    func didChangeAddress(text: String)
    func didChangeRegion(text: String)
    func didSelectPickerRow(row: Int, in component: Int)
    
    func didPressSave()
}

protocol EventCreationInteractorOutputting: AnyObject {
    
}

class EventCreationPresenter {
    
    // MARK: VIPER
    
    weak var router: EventCreationRouter?
    var view: EventCreationViewOutputting?
    var interactor: EventCreationInteractorInputting?
    
    // MARK: Properties
    
    private var eventType: EventType = .birthday
    private var eventFirstName = ""
    private var eventLastName = ""
    private var eventAddress = ""
    private var eventRegion = ""
    private var eventMonth = 0
    private var eventYear = 0
    private var eventDay = 0
    
    private var displayName: String {
        if eventFirstName.isEmpty {
            return "\(eventType.emoji) \(eventType.rawValue.capitalized)"
        } else if eventLastName.isEmpty {
            return "\(eventType.emoji) \(eventFirstName)"
        } else {
            return "\(eventType.emoji) \(eventFirstName) \(String(eventLastName.prefix(1)))"
        }
    }
    
    private let calendarManager = CalendarManager(initialYear: 1920)
    
    // MARK: Initialization
    
    // MARK: Private Helpers
}

// MARK: EventCreationEventHandling

extension EventCreationPresenter: EventCreationEventHandling {
    
    func viewDidLoad() {
        view?.configureNavigationButton()
        view?.configureNavigation(title: displayName)
        view?.selectEventType(eventType)
        
        view?.populateView(
            content: EventCreationView.Content(
                months: calendarManager.formattedMonths(),
                years: calendarManager.formattedYears(),
                days: calendarManager.formattedDaysFor(month: 6, year: 1970)
            )
        )
        
        view?.selectMonth(index: 5)
        view?.selectYear(index: 50)
        view?.selectDay(index: 14)
    }
    
    func didSelectEventType(eventType: EventType) {
        guard self.eventType != eventType else { return }
        self.eventType = eventType
        view?.selectEventType(self.eventType)
        view?.configureNavigation(title: displayName)
    }
    
    func didChangeFirstName(text: String) {
        eventFirstName = text
        view?.configureNavigation(title: displayName)
    }
    
    func didChangeLastName(text: String) {
        eventLastName = text
        view?.configureNavigation(title: displayName)
    }
    
    func didChangeAddress(text: String) {
        eventAddress = text
    }
    
    func didChangeRegion(text: String) {
        eventRegion = text
    }
    
    func didToggleYearPicker(isOn: Bool) {
        if isOn {
            view?.selectYear(index: eventYear)
        }
    }
    
    func didSelectPickerRow(row: Int, in component: Int) {
        switch component {
        case 0:
            eventMonth = row
            let days = calendarManager.formattedDaysFor(month: row, year: eventYear)
            view?.populateDays(days)
        case 1:
            eventDay = row
        case 2:
            eventYear = row
            let days = calendarManager.formattedDaysFor(month: eventMonth, year: row)
            view?.populateDays(days)
        default:
            return
        }
    }
    
    func didPressSave() {
        print("first name: \(eventFirstName)")
        print("last name: \(eventLastName)")
        print("address: \(eventAddress)")
        print("region: \(eventRegion)")
        print("date: \(calendarManager.getDate(monthIndex: eventMonth, dayIndex: eventDay, yearIndex: eventYear))")
    }
}

// MARK: EventCreationInteractorOutputting

extension EventCreationPresenter: EventCreationInteractorOutputting {
    
}
