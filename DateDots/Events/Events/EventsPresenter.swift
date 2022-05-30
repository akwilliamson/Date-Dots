//
//  EventsPresenter.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

protocol EventsEventHandling: AnyObject {
    
    func viewDidLoad()
    func viewWillAppear()
    
    func composeButtonPressed()
    func searchButtonPressed()
    func cancelButtonPressed()
    func addButtonPressed()
    
    func searchTextChanged(text: String)
    
    func eventDotPressed(type: EventType)
    func noteDotPressed(type: NoteType)
    
    func selectEventPressed(event: Event)
    func selectNotePressed(noteState: NoteState)
}

protocol EventsInteractorOutputting: AnyObject {
    
    func eventsFetched(_ events: [Event])
    func eventsFetchedFailed(_ error: EventsInteractorError)
    func remindersFetched()
    func reminderFound(for event: Event, reminder: UNNotificationRequest)
    func reminderNotFound(for event: Event)
}

class EventsPresenter {

    // MARK: VIPER
    
    weak var router: EventsRouter?
    var view: EventsViewOutputting?
    var interactor: EventsInteractorInputting?

    // MARK: Constants
    
    enum NavigationState {
        case normal
        case search
    }

    // MARK: Properties
    
    private let userDefaultsManager = UserDefaultsManager()
    
    private var reminders: [UNNotificationRequest] = []
    
    private var events: [Event] = []
    
    private var activeEventTypes: [EventType] {
        return [.birthday, .anniversary, .custom].filter {
            userDefaultsManager.getBool(type: $0.rawValue, for: .filterEvent)
        }
    }
    
    private var inactiveEventTypes: [EventType] {
        return [.birthday, .anniversary, .custom].filter {
            !userDefaultsManager.getBool(type: $0.rawValue, for: .filterEvent)
        }
    }
    
    private var activeNoteTypes: [NoteType] {
        return [.gifts, .plans, .misc].filter {
            userDefaultsManager.getBool(type: $0.rawValue, for: .filterNote)
        }
    }
    
    private var inactiveNoteTypes: [NoteType] {
        return [.gifts, .plans, .misc].filter {
            !userDefaultsManager.getBool(type: $0.rawValue, for: .filterNote)
        }
    }
    
    private var activeEvents: [Event] {
        events.filter { activeEventTypes.contains($0.eventType) }
    }
    
    private var sortedActiveEvents: [Event] {
        activeEvents.shiftSorted()
    }
    
    private var isSearching = false
    
    // MARK: Private Helpers
    
    private func setupDots() {

        activeEventTypes.forEach {
            view?.toggleDotFor(eventType: $0, isSelected: true)
        }
        inactiveEventTypes.forEach {
            view?.toggleDotFor(eventType: $0, isSelected: false)
        }
        activeNoteTypes.forEach {
            view?.toggleDotFor(noteType: $0, isSelected: true)
        }
        inactiveNoteTypes.forEach {
            view?.toggleDotFor(noteType: $0, isSelected: false)
        }
        
        if activeEvents.isEmpty {
            view?.hideNoteDots()
        } else {
            view?.showNoteDots()
        }
    }
    
    private func toggleFilterFor(eventType: EventType) -> Bool {
        let old = userDefaultsManager.getBool(type: eventType.rawValue, for: .filterEvent)
        userDefaultsManager.setBool(!old, type: eventType.rawValue, for: .filterEvent)

        let params = ["eventType": eventType.rawValue, "isOn": "\(!old)"]
        Flurry.log(eventName: "Toggle Event Type", parameters: params)
        
        return !old

    }
    
    private func toggleFilterFor(noteType: NoteType) -> Bool {
        let old = userDefaultsManager.getBool(type: noteType.rawValue, for: .filterNote)
        userDefaultsManager.setBool(!old, type: noteType.rawValue, for: .filterNote)
        
        let params = ["noteType": noteType.rawValue, "isOn": "\(!old)"]
        Flurry.log(eventName: "Toggle Note Type", parameters: params)
        
        return !old
    }
}

// MARK: - EventsEventHandling

extension EventsPresenter: EventsEventHandling {

    func viewDidLoad() {
        let dateText = Date().formatted("MMM dd")
        view?.configureNavigation(title: dateText)
    }
    
    func viewWillAppear() {
        interactor?.fetchReminders()
        view?.configureNavigation(state: .normal)
        
        let saveEventCount = userDefaultsManager.getInt(for: .countEventSave)

        if saveEventCount > 0 && saveEventCount % 10 == 0 {
            if let date = userDefaultsManager.getTime(for: .timeSinceLastPrompt) {
                let daysSinceLastPrompt = Calendar.current.dateComponents([.day], from: date, to: Date()).day!
                if daysSinceLastPrompt > 60 {
                    userDefaultsManager.setTime(Date(), for: .timeSinceLastPrompt)
                    view?.presentAppReviewModal()
                }
            } else {
                userDefaultsManager.setTime(Date(), for: .timeSinceLastPrompt)
                view?.presentAppReviewModal()
            }
        }
    }
    
    func composeButtonPressed() {
        let recipient = "datedots@gmail.com"
        let subject = "Feedback/Request"
        let body = "Feedback or feature requests? Let me know here!"
        view?.presentMailComposer(recipient: recipient, subject: subject, body: body)
    }
    
    func searchButtonPressed() {
        isSearching = true
        view?.configureNavigation(state: .search)
    }
    
    func cancelButtonPressed() {
        isSearching = false
        interactor?.getEvents()
        view?.configureNavigation(state: .normal)
    }
    
    func addButtonPressed() {
        router?.presentEventCreation()
    }
    
    func searchTextChanged(text: String) {
        interactor?.getEvents(containing: text)
    }

    func eventDotPressed(type: EventType) {
        let isSelected = toggleFilterFor(eventType: type)
        view?.toggleDotFor(eventType: type, isSelected: isSelected)
        view?.populateView(activeEvents: sortedActiveEvents, activeNoteTypes: activeNoteTypes)
        view?.reloadView()
        
        if sortedActiveEvents.isEmpty {
            view?.hideNoteDots()
        } else {
            view?.showNoteDots()
        }
    }
    
    func noteDotPressed(type: NoteType) {
        let isSelected = toggleFilterFor(noteType: type)
        view?.toggleDotFor(noteType: type, isSelected: isSelected)
        view?.populateView(activeEvents: sortedActiveEvents, activeNoteTypes: activeNoteTypes)
        view?.reloadView()
    }
    
    func selectEventPressed(event: Event) {
        if event.hasReminder {
            Dispatch.background {
                self.interactor?.findReminder(for: event)
            }
        } else {
            let eventDetails = EventDetails(event: event, reminder: nil)
            router?.presentEventDetails(eventDetails: eventDetails)
        }
    }
    
    func selectNotePressed(noteState: NoteState) {
        router?.presentEventNote(noteState: noteState)
    }
}

// MARK: - EventsInteractorOutputting

extension EventsPresenter: EventsInteractorOutputting {
    
    func eventsFetched(_ events: [Event]) {
        self.events = events
        setupDots()
        view?.populateView(
            activeEvents: sortedActiveEvents,
            activeNoteTypes: activeNoteTypes
        )
        view?.reloadView()
    }
    
    func eventsFetchedFailed(_ error: EventsInteractorError) {
        print(error.localizedDescription)
    }
    
    func remindersFetched() {
        interactor?.fetchEvents()
    }
    
    func reminderFound(for event: Event, reminder: UNNotificationRequest) {
        let eventDetails = EventDetails(event: event, reminder: reminder)
        router?.presentEventDetails(eventDetails: eventDetails)
    }
    
    func reminderNotFound(for event: Event) {
        let eventDetails = EventDetails(event: event, reminder: nil)
        router?.presentEventDetails(eventDetails: eventDetails)
    }
}
