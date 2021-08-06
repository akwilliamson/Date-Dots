//
//  EventCreationPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/25/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UserNotifications

protocol EventCreationEventHandling: AnyObject {
    
    func viewDidLoad()
    func didSelectEventType(eventType: EventType)
    func didToggleYearPicker(isOn: Bool)
    func didChangeFirstName(text: String)
    func didChangeLastName(text: String)
    func didChangeAddress(text: String)
    func didChangeRegion(text: String)
    func didSelectPickerRow(row: Int, in component: Int)
    func didTapSave()
    func didTapDelete()
    func didConfirmDelete()
    func textFieldDidReturn()
}

protocol EventCreationInteractorOutputting: AnyObject {
    
    func eventDeleteFailed(error: Error)
    func eventDeleteSucceeded()
    func handleEventReminder(reminder: UNNotificationRequest?)
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
    
    private let notificationManager = NotificationManager()
    
    private var shouldSaveDynamically = false
    
    private var navigationTitle: String {
        let prefix = eventType.emoji
        let suffix: String
        
        if eventGivenName.isEmpty {
            suffix = eventType.rawValue.capitalized
        } else if eventFamilyName.isEmpty {
            suffix = eventGivenName
        } else {
            suffix = "\(eventGivenName) \(String(eventFamilyName.prefix(1)))"
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
            self.shouldSaveDynamically = true
            
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
        view?.configureNavigation(title: navigationTitle)
        if event != nil {
            view?.configureNavigationDeleteButton()
        } else {
            view?.configureNavigationSaveButton()
        }
        
        view?.populateView(
            content: EventCreationView.Content(
                eventType: eventType,
                showYear: datePickerManager.yearIsEnabled,
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
        
        if shouldSaveDynamically, let event = self.event {
            event.type = eventType.rawValue
            interactor?.saveEvent(event)
        }
        
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
     
        if shouldSaveDynamically, let event = self.event {
            event.date = datePickerManager.eventDate
            interactor?.saveEvent(event)
        }
        
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
        
        if shouldSaveDynamically, let event = self.event {
            event.date = datePickerManager.eventDate
            interactor?.saveEvent(event)
        }
    }
    
    func didTapSave() {
        guard !eventGivenName.isEmpty else {
            view?.showInputError()
            return
        }

        if let event = event {
            interactor?.findReminder(for: event)
        } else {
            createNewEvent()
        }
    }
    
    func didTapDelete() {
        view?.showConfirmDelete()
    }
    
    func didConfirmDelete() {
        if let event = event {
            notificationManager.removeNotification(with: event.id)
            interactor?.deleteEvent(event)
        }
    }
    
    func textFieldDidReturn() {
        if shouldSaveDynamically, let event = self.event {
            if !eventGivenName.isEmpty {
                event.givenName = eventGivenName
            }
            event.familyName = eventFamilyName
            
            if !eventStreet.isEmpty || !eventRegion.isEmpty {
                if let address = event.address {
                    address.street = eventStreet
                    address.region = eventRegion
                } else {
                    let address = Address(context: CoreDataManager.shared.viewContext)
                    address.street = eventStreet
                    address.region = eventRegion
                    event.address = address
                }
            }
            interactor?.saveEvent(event)
        }
    }
    
    private func createNewEvent() {
        let newEvent = Event(context: CoreDataManager.shared.viewContext)
        
        // Deprecated
        newEvent.name            = "DEPRECATED"
        newEvent.abbreviatedName = "DEPRECATED"
        newEvent.equalizedDate   = "DEPRECATED"
        
        newEvent.type = eventType.rawValue
        newEvent.date = datePickerManager.eventDate
        newEvent.givenName = eventGivenName
        newEvent.familyName = eventFamilyName
        
        if !eventStreet.isEmpty || !eventRegion.isEmpty {
            let address = Address(context: CoreDataManager.shared.viewContext)
            address.street = eventStreet
            address.region = eventRegion
            newEvent.address = address
        }
        
        interactor?.saveEvent(newEvent)
    }
}

// MARK: EventCreationInteractorOutputting

extension EventCreationPresenter: EventCreationInteractorOutputting {
    
    func eventDeleteFailed(error: Error) {
        router?.dismiss(event: nil)
    }
    
    func eventDeleteSucceeded() {
        router?.dismiss(event: nil)
    }
    
    func handleEventReminder(reminder: UNNotificationRequest?) {
        guard let editedEvent = event else { return }
        
        if let reminder = reminder {
            rescheduleReminder(reminder, for: editedEvent)
        }
        
        // Deprecated
        editedEvent.name            = "DEPRECATED"
        editedEvent.abbreviatedName = "DEPRECATED"
        editedEvent.equalizedDate   = "DEPRECATED"
        
        editedEvent.type = eventType.rawValue
        editedEvent.date = datePickerManager.eventDate
        editedEvent.givenName = eventGivenName
        editedEvent.familyName = eventFamilyName
        
        if !eventStreet.isEmpty || !eventRegion.isEmpty {
            if let address = event?.address {
                address.street = eventStreet
                address.region = eventRegion
            } else {
                let address = Address(context: CoreDataManager.shared.viewContext)
                address.street = eventStreet
                address.region = eventRegion
                event?.address = address
            }
        }
        
        interactor?.saveEvent(editedEvent)
    }
    
    private func rescheduleReminder(_ reminder: UNNotificationRequest, for event: Event) {
        guard
            let trigger = reminder.trigger as? UNCalendarNotificationTrigger
        else {
            print("qwerty no reminder found")
            return
        }
        
        // Find the trigger date's days preceding the existing date
        let diffInDays = Calendar.current.days(from: trigger.nextTriggerDate()!, to: event.date)
        
        // Set same days preceding the new date for the new trigger date
        let newTriggerDateComponents = DateComponents(
            day: datePickerManager.eventDate.day! - diffInDays,
            hour: trigger.dateComponents.hour,
            minute: trigger.dateComponents.minute)
        
        let reminder = Reminder(
            id: event.id,
            title: reminder.content.title,
            body: reminder.content.body,
            fireDate: newTriggerDateComponents
        )
        
        interactor?.saveReminder(reminder)
    }
}
