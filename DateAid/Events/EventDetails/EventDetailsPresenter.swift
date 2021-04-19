//
//  EventDetailsPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/14/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

protocol EventDetailsEventHandling: class {
    
    func viewDidLoad()
    func viewWillAppear()
    
    func infoDotPressed(type: InfoType)
    func noteDotPressed(type: NoteType)
}

class EventDetailsPresenter {
    
    // MARK: VIPER
    
    var view: EventDetailsViewOutputting?
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
        let title = "\(event.abbreviatedName) \(event.eventType.emoji)"
        view?.configureNavigation(title: title)
    }
    
    func viewWillAppear() {
        view?.setDetailsFor(event: event)
        view?.selectDotFor(infoType: activeInfoType)
    }
    
    func infoDotPressed(type: InfoType) {
        setPreferenceFor(infoType: type)
        view?.selectDotFor(infoType: activeInfoType)
    }
    
    func noteDotPressed(type: NoteType) {
        print("TODO: Animate to selected note view, set note view preference")
    }
}
