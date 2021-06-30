//
//  EventsPresenter.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventsEventHandling: AnyObject {
    
    func viewDidLoad()
    func viewWillAppear()
    
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
    
    private var events: [Event] = []
    
    private var activeEventTypes: [EventType] {
        return [.birthday, .anniversary, .custom, .other].filter {
            UserDefaults.standard.bool(forKey: $0.key)
        }
    }
    
    private var inactiveEventTypes: [EventType] {
        return [.birthday, .anniversary, .custom, .other].filter {
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
        let sortedEvents = activeEvents.sorted { $0.formattedDate < $1.formattedDate }
        let now = Date().formatted("MM/dd")
        
        let currentEvents = sortedEvents.sorted { (event1, event2) in
            if event1.formattedDate >= now && event2.formattedDate < now {
                return event1.formattedDate > event2.formattedDate
            } else {
                return event1.formattedDate < event2.formattedDate
            }
        }
        return currentEvents
    }
    
    private var isSearching = false
    
    private let notificationManager = NotificationManager()
    
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
        
        return newPreference
    }
    
    private func togglePreferenceFor(noteType: NoteType) -> Bool {
        let userDefaults = UserDefaults.standard
        let oldPreference = userDefaults.bool(forKey: noteType.key)
        let newPreference = !oldPreference
        userDefaults.set(newPreference, forKey: noteType.key)
        
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
        interactor?.fetchEvents()
        view?.configureNavigation(state: .normal)
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
        view?.populateView(activeEvents: activeEvents, activeNoteTypes: activeNoteTypes)
        view?.reloadView()
        
        if activeEvents.isEmpty {
            view?.hideNoteDots()
        } else {
            view?.showNoteDots()
        }
    }
    
    func noteDotPressed(type: NoteType) {
        let isSelected = togglePreferenceFor(noteType: type)
        view?.toggleDotFor(noteType: type, isSelected: isSelected)
        view?.populateView(activeEvents: activeEvents, activeNoteTypes: activeNoteTypes)
        view?.reloadView()
    }
    
    func selectEventPressed(event: Event) {
        router?.presentEventDetails(event: event)
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
        view?.populateView(activeEvents: activeEvents, activeNoteTypes: activeNoteTypes)
        view?.reloadView()
    }
    
    func eventsFetchedFailed(_ error: EventsInteractorError) {
        print(error.localizedDescription)
    }
}
