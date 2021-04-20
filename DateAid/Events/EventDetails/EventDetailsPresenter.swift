//
//  EventDetailsPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/14/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UserNotifications

protocol EventDetailsEventHandling: class {
    
    func viewDidLoad()
    func viewWillAppear()
    
    func infoDotPressed(type: InfoType)
    func noteDotPressed(type: NoteType)
}

protocol EventDetailsInteractorOutputting: class {
    
    func handleNotificationNotFound()
    func handleNotification(daysBefore: Int, timeOfDay: Date)
}

class EventDetailsPresenter {
    
    // MARK: VIPER
    
    var view: EventDetailsViewOutputting?
    var interactor: EventDetailsInteractorInputting?
    weak var wireframe: EventDetailsWireframe?
    
    // MARK: Properties
    
    private var event: Event
    
    private var activeInfoType: InfoType {
        return UserDefaults.standard.bool(forKey: InfoType.reminder.key) ? .reminder : .address
    }
    
    // MARK: Initialization
    
    init(event: Event) {
        self.event = event
    }
    
    // MARK: Private Helpers
    
    private func setPreferenceFor(infoType: InfoType) {
        let userDefaults = UserDefaults.standard
        switch infoType {
        case .address:
            userDefaults.set(false, forKey: InfoType.reminder.key)
        case .reminder:
            userDefaults.set(true, forKey: InfoType.reminder.key)
        }
    }
}

// MARK: - EventDetailsEventHandling

extension EventDetailsPresenter: EventDetailsEventHandling {
    
    func viewDidLoad() {
        let title = "\(event.eventType.emoji) \(event.givenName)"
        view?.configureNavigation(title: title)
    }
    
    func viewWillAppear() {
        interactor?.fetchNotification(id: event.objectIDString)
        view?.setInitialSelected(infoType: activeInfoType)
    }
    
    func infoDotPressed(type: InfoType) {
        setPreferenceFor(infoType: type)
        view?.selectDotFor(infoType: activeInfoType)
    }
    
    func noteDotPressed(type: NoteType) {
        print("TODO: Animate to selected note view, set note view preference")
    }
}

// MARK: - EventDetailsInteractorOutputting

extension EventDetailsPresenter: EventDetailsInteractorOutputting {
    
    func handleNotification(daysBefore: Int, timeOfDay: Date) {
        view?.setDetailsFor(event: event, daysBefore: daysBefore, timeOfDay: timeOfDay)
    }
    
    func handleNotificationNotFound() {
        view?.setDetailsFor(event: event, daysBefore: nil, timeOfDay: nil)
    }
}
