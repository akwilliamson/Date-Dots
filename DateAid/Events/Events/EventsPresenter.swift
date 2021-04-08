//
//  EventsPresenter.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventsEventHandling: class {
    
    func viewDidLoad()
    func viewWillAppear()
    
    func searchButtonPressed()
    func cancelButtonPressed()
    func addButtonPressed()
    
    func eventDotPressed(type: EventType)
    func noteDotPressed(type: NoteType)
    
    func deleteEventPressed(event: Event)
    func selectEventPressed(event: Event)

    func searchTextChanged(text: String)
}

protocol EventsInteractorOutputting: class {
    
    func eventsFetched(_ events: [Event])
    func eventsFetchedFailed(_ error: EventsInteractorError)
    func eventDeleted(_ event: Event)
    func eventDeleteFailed(_ error: EventsInteractorError)
}

class EventsPresenter {

    // MARK: VIPER
    
    public var view: EventsViewOutputting?
    public var interactor: EventsInteractorInputting?
    public weak var wireframe: EventsWireframe?

    // MARK: Constants

    private enum Constant {
        enum Image {
            static let iconSelected = UIImage(named: "selected-calendar")!.withRenderingMode(.alwaysTemplate)
            static let iconUnselected =  UIImage(named: "unselected-calendar")!.withRenderingMode(.alwaysTemplate)
        }
    }
    
    enum NavigationState {
        case initial
        case normal
        case search
    }

    // MARK: Properties
    
    private var events: [Event] = []
    
    private var activeEventTypes: [EventType] {
        return [.birthday, .anniversary, .holiday, .other].filter {
            UserDefaults.standard.bool(forKey: $0.rawValue)
        }
    }
    
    private var inactiveEventTypes: [EventType] {
        return [.birthday, .anniversary, .holiday, .other].filter {
            !UserDefaults.standard.bool(forKey: $0.rawValue)
        }
    }
    
    private var activeEvents: [Event] {
        let activeEvents = events.filter { activeEventTypes.contains($0.eventType) }
        let today = Date().formatted("MM/dd")
        let sortedEvents = activeEvents.sorted { $0.equalizedDate < $1.equalizedDate }
        let currentEvents = sortedEvents.sorted { (event1, event2) in
            if event1.equalizedDate >= today && event2.equalizedDate < today {
                return event1.equalizedDate > event2.equalizedDate
            } else {
                return event1.equalizedDate < event2.equalizedDate
            }
        }
        return currentEvents
    }
    
    private var isSearching = false
    private var deleteEventType: EventType?
    
    private let notificationManager = NotificationManager()
}

// MARK: - EventsEventHandling

extension EventsPresenter: EventsEventHandling {
    
    func viewDidLoad() {
        setupNavigation()
        setupDots()
    }
    
    func viewWillAppear() {
        interactor?.fetchEvents()
        view?.configureNavigation(state: .initial)
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
        // TODO: Navigate to new event
    }

    func eventDotPressed(type: EventType) {
        let isSelected = togglePreferenceFor(eventType: type)
        view?.toggleDotFor(type, isSelected: isSelected)
        view?.reload(events: activeEvents)
    }
    
    func noteDotPressed(type: NoteType) {
        // TODO: signify which notes to show/hide
    }
    
    func deleteEventPressed(event: Event) {
        deleteEventType = event.eventType
        interactor?.delete(event)
    }
    
    func selectEventPressed(event: Event) {
        // TODO: Navigate to existing event
    }
    
    func searchTextChanged(text: String) {
        interactor?.getEvents(containing: text)
    }
    
    // MARK: Private Helpers
    
    private func setupNavigation() {
        let dateText = Date().formatted("MMM dd")
        view?.configureNavigation(title: dateText)
    }
    
    private func setupDots() {
        activeEventTypes.forEach {
            view?.toggleDotFor($0, isSelected: true)
        }
        
        inactiveEventTypes.forEach {
            view?.toggleDotFor($0, isSelected: false)
        }
    }
    
    private func togglePreferenceFor(eventType: EventType) -> Bool {
        let userDefaults = UserDefaults.standard
        let oldPreference = userDefaults.bool(forKey: eventType.rawValue)
        let newPreference = !oldPreference
        userDefaults.set(newPreference, forKey: eventType.rawValue)
        
        return newPreference
    }
}

// MARK: - EventsInteractorOutputting

extension EventsPresenter: EventsInteractorOutputting {
    
    func eventsFetched(_ events: [Event]) {
        self.events = events
        view?.reload(events: activeEvents)
    }
    
    func eventsFetchedFailed(_ error: EventsInteractorError) {
        print(error.localizedDescription)
    }
    
    func eventDeleted(_ event: Event) {
        notificationManager.cancelNotificationWith(identifier: event.objectIDString)

        events.removeAll(where: { $0.objectID == event.objectID })
        view?.removeRowFor(event: event)
    }
    
    func eventDeleteFailed(_ error: EventsInteractorError) {
        print(error.localizedDescription)
    }
}
