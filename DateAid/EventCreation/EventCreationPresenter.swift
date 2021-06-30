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
    
    func saveSucceeded()
    func saveFailed(error: Error)
}

class EventCreationPresenter {
    
    // MARK: VIPER
    
    weak var router: EventCreationRouter?
    var view: EventCreationViewOutputting?
    var interactor: EventCreationInteractorInputting?
    
    // MARK: Properties
    
    private var eventManager: EventCreationManager
    private let datePickerManager: DatePickerManager
    
    private var yearIsActive = true
    
    private var displayName: String {
        if eventManager.firstName.isEmpty {
            return "\(eventManager.eventType.emoji) \(eventManager.eventType.rawValue.capitalized)"
        } else if eventManager.lastName.isEmpty {
            return "\(eventManager.eventType.emoji) \(eventManager.firstName)"
        } else {
            return "\(eventManager.eventType.emoji) \(eventManager.firstName) \(String(eventManager.lastName.prefix(1)))"
        }
    }
    
    // MARK: Initialization
    
    init(event: Event?) {
        self.eventManager = EventCreationManager(event: event)
        self.datePickerManager = DatePickerManager(date: event?.date)
    }
}

// MARK: EventCreationEventHandling

extension EventCreationPresenter: EventCreationEventHandling {
    
    func viewDidLoad() {
        view?.configureNavigationButton()
        view?.configureNavigation(title: displayName)
        
        view?.populateView(
            content: EventCreationView.Content(
                eventType: eventManager.eventType,
                firstName: eventManager.firstName,
                lastName: eventManager.lastName,
                street: eventManager.street,
                region: eventManager.region,
                selectedDay: datePickerManager.selectedDay,
                selectedMonth: datePickerManager.selectedMonth,
                selectedYear: datePickerManager.selectedYearIndex,
                days: datePickerManager.days,
                months: datePickerManager.months,
                years: datePickerManager.years
            )
        )
    }
    
    func didSelectEventType(eventType: EventType) {
        guard eventManager.eventType != eventType else { return }
        eventManager.setEventType(eventType)
        
        view?.selectEventType(eventType)
        view?.configureNavigation(title: displayName)
    }
    
    func didChangeFirstName(text: String) {
        eventManager.setFirstName(text)
        
        view?.configureNavigation(title: displayName)
    }
    
    func didChangeLastName(text: String) {
        eventManager.setLastName(text)
        
        view?.configureNavigation(title: displayName)
    }
    
    func didChangeAddress(text: String) {
        eventManager.setStreet(text)
    }
    
    func didChangeRegion(text: String) {
        eventManager.setRegion(text)
    }
    
    func didToggleYearPicker(isOn: Bool) {
        yearIsActive = isOn
        
        if yearIsActive {
            view?.selectYear(index: datePickerManager.selectedYearIndex)
        }
    }
    
    func didSelectPickerRow(row: Int, in component: Int) {
        switch component {
        case 0:
            datePickerManager.setMonth(row)
            view?.populateDays(datePickerManager.days)
        case 1:
            datePickerManager.setDay(row)
        case 2:
            datePickerManager.setYear(row)
            view?.populateDays(datePickerManager.days)
        default:
            return
        }
    }
    
    func didPressSave() {
        guard !eventManager.firstName.isEmpty else {
            view?.showInputError()
            return
        }
        
        eventManager.setEventDate(
            createDate(
                month: datePickerManager.selectedMonth,
                day: datePickerManager.selectedDay,
                year: yearIsActive ? datePickerManager.selectedYear : 2100
            )
        )
        
        interactor?.saveEvent(eventManager.event)
    }
    
    // MARK: Private Methods
    
    private func createDate(month: Int, day: Int, year: Int = 2100) -> Date {
        let dateComponents = DateComponents(year: year, month: month+1, day: day+1)
        
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
}

// MARK: EventCreationInteractorOutputting

extension EventCreationPresenter: EventCreationInteractorOutputting {
    
    func saveSucceeded() {
        router?.dismiss()
    }
    
    func saveFailed(error: Error) {
        view?.showSaveError()
    }
}
