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
    
    func eventSaveFailed(error: Error)
    func eventSaveSucceeded(event: Event)
}

class EventCreationPresenter {
    
    // MARK: VIPER
    
    weak var router: EventCreationRouter?
    var view: EventCreationViewOutputting?
    var interactor: EventCreationInteractorInputting?
    
    // MARK: Properties
    
    private var event: Event?
    
    private var eventType = EventType.birthday
    private var eventGivenName = String()
    private var eventFamilyName = String()
    private var eventStreet = String()
    private var eventRegion = String()
    private var eventDate = Date()
    
    private let datePickerManager: DatePickerManager
    
    private var navigationTitle: String {
        let prefix = eventType.emoji
        let suffix: String
        
        if eventGivenName.isEmpty {
            suffix = eventType.rawValue.capitalized
        } else if eventFamilyName.isEmpty {
            suffix = eventGivenName
        } else {
            suffix = "\(eventGivenName) \(String(eventGivenName.prefix(1)))"
        }
        
        return [prefix, suffix].joined(separator: " ")
    }
    
    // MARK: Initialization
    
    init(event: Event?) {
        if let event = event {
            self.event = event
            self.eventType = event.eventType
            self.eventGivenName = event.givenName
            self.eventFamilyName = event.familyName
            
            if let street = event.address?.street {
                self.eventStreet = street
            }
            if let region = event.address?.region {
                self.eventRegion = region
            }
        }
        self.datePickerManager = DatePickerManager(date: event?.date)
    }
}

// MARK: EventCreationEventHandling

extension EventCreationPresenter: EventCreationEventHandling {
    
    func viewDidLoad() {
        view?.configureNavigationButton()
        view?.configureNavigation(title: navigationTitle)
        
        view?.populateView(
            content: EventCreationView.Content(
                eventType: eventType,
                firstName: eventGivenName,
                lastName: eventFamilyName,
                street: eventStreet,
                region: eventRegion,
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
        guard self.eventType != eventType else { return }
        self.eventType = eventType
        
        view?.selectEventType(eventType)
        view?.configureNavigation(title: navigationTitle)
    }
    
    func didChangeFirstName(text: String) {
        eventGivenName = text
        view?.configureNavigation(title: navigationTitle)
    }
    
    func didChangeLastName(text: String) {
        eventFamilyName = text
        view?.configureNavigation(title: navigationTitle)
    }
    
    func didChangeAddress(text: String) {
        eventStreet = text
    }
    
    func didChangeRegion(text: String) {
        eventRegion = text
    }
    
    func didToggleYearPicker(isOn: Bool) {
        datePickerManager.yearIsEnabled = isOn
        
        if isOn {
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
        guard !eventGivenName.isEmpty else {
            view?.showInputError()
            return
        }
        
        let eventToSave: Event
        
        if let event = event {
            eventToSave = event
        } else {
            eventToSave = Event(context: CoreDataManager.shared.viewContext)
        }
        
        // Deprecated
        eventToSave.name            = "DEPRECATED"
        eventToSave.abbreviatedName = "DEPRECATED"
        eventToSave.equalizedDate   = "DEPRECATED"
        
        eventToSave.type = eventType.rawValue
        eventToSave.date = datePickerManager.eventDate
        eventToSave.givenName = eventGivenName
        eventToSave.familyName = eventFamilyName
        
        if !eventStreet.isEmpty || !eventRegion.isEmpty {
            let address = Address(context: CoreDataManager.shared.viewContext)
            address.street = eventStreet
            address.region = eventRegion
            eventToSave.address = address
        }
        
        interactor?.saveEvent(eventToSave)
    }
}

// MARK: EventCreationInteractorOutputting

extension EventCreationPresenter: EventCreationInteractorOutputting {
    
    func eventSaveFailed(error: Error) {
        view?.showSaveError()
    }
    
    func eventSaveSucceeded(event: Event) {
        router?.dismiss(data: event)
    }
}
