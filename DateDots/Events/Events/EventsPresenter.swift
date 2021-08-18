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
    
    private var reminders: [UNNotificationRequest] = []
    
    private var events: [Event] = []
    
    private var activeEventTypes: [EventType] {
        return [.birthday, .anniversary, .custom].filter {
            UserDefaults.standard.bool(forKey: $0.key)
        }
    }
    
    private var inactiveEventTypes: [EventType] {
        return [.birthday, .anniversary, .custom].filter {
            !UserDefaults.standard.bool(forKey: $0.key)
        }
    }
    
    private var activeNoteTypes: [NoteType] {
        return [.gifts, .plans, .misc].filter {
            UserDefaults.standard.bool(forKey: $0.key)
        }
    }
    
    private var inactiveNoteTypes: [NoteType] {
        return [.gifts, .plans, .misc].filter {
            !UserDefaults.standard.bool(forKey: $0.key)
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
    
    private func togglePreferenceFor(eventType: EventType) -> Bool {
        let userDefaults = UserDefaults.standard
        let oldPreference = userDefaults.bool(forKey: eventType.key)
        let newPreference = !oldPreference
        userDefaults.set(newPreference, forKey: eventType.key)
        
        let params = ["eventType": eventType.rawValue, "isOn": "\(newPreference)"]
        Flurry.logEvent("Toggle Event Type", withParameters: params)
        
        return newPreference
    }
    
    private func togglePreferenceFor(noteType: NoteType) -> Bool {
        let userDefaults = UserDefaults.standard
        let oldPreference = userDefaults.bool(forKey: noteType.key)
        let newPreference = !oldPreference
        userDefaults.set(newPreference, forKey: noteType.key)
        
        let params = ["noteType": noteType.rawValue, "isOn": "\(newPreference)"]
        Flurry.logEvent("Toggle Note Type", withParameters: params)
        
        return newPreference
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
    }
    
    func composeButtonPressed() {
        let recipient = "datedots@gmail.com"
        let subject = "Feedback"
        let body = "Feedback or feature requests? Leave them here!"
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
        let isSelected = togglePreferenceFor(eventType: type)
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
        let isSelected = togglePreferenceFor(noteType: type)
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
