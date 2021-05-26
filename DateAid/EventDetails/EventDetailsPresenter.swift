//
//  EventDetailsPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/14/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UserNotifications

protocol EventDetailsEventHandling: AnyObject {
    
    func viewDidLoad()
    func viewWillAppear()
    
    func didSelect(infoType: InfoType)
    func didSelect(noteType: NoteType)
    func didSelectNoteView(note: Note?, noteType: NoteType?)
}

protocol EventDetailsInteractorOutputting: AnyObject {
    
    func handleNotificationNotFound()
    func handleNotification(daysBefore: Int, timeOfDay: Date)
}

class EventDetailsPresenter {
    
    // MARK: VIPER
    
    weak var router: EventDetailsRouter?
    var view: EventDetailsViewOutputting?
    var interactor: EventDetailsInteractorInputting?
    
    // MARK: Constant
    
    private enum Constant {
        static let keyPrefix = "eventdetails-"
    }
    
    // MARK: Properties
    
    private var event: Event
    
    private var activeInfoType: InfoType {
        let key = "\(Constant.keyPrefix)\(InfoType.reminder.key)"
        return UserDefaults.standard.bool(forKey: key) ? .reminder : .address
    }
    
    private var activeNoteType: NoteType {
        return [.gifts, .plans, .other].filter {
            UserDefaults.standard.bool(forKey: "\(Constant.keyPrefix)\($0.key)")
        }.first ?? .gifts
    }
    
    // MARK: Initialization
    
    init(event: Event) {
        self.event = event
    }
    
    // MARK: Private Helpers
    
    private func setPreferenceFor(infoType: InfoType) {
        let userDefaults = UserDefaults.standard
        let key = "\(Constant.keyPrefix)\(InfoType.reminder.key)"
        switch infoType {
        case .address:
            userDefaults.set(false, forKey: key)
        case .reminder:
            userDefaults.set(true, forKey: key)
        }
    }
    
    private func setPreferenceFor(noteType: NoteType) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: "\(Constant.keyPrefix)\(NoteType.gifts.key)")
        userDefaults.set(false, forKey: "\(Constant.keyPrefix)\(NoteType.plans.key)")
        userDefaults.set(false, forKey: "\(Constant.keyPrefix)\(NoteType.other.key)")
        
        userDefaults.set(true, forKey: "\(Constant.keyPrefix)\(noteType.key)")
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
    }
    
    func didSelect(infoType: InfoType) {
        setPreferenceFor(infoType: infoType)
        view?.select(infoType: activeInfoType)
    }
    
    func didSelect(noteType: NoteType) {
        setPreferenceFor(noteType: noteType)
        view?.select(noteType: activeNoteType)
    }
    
    func didSelectNoteView(note: Note?, noteType: NoteType?) {
        if let note = note {
            let noteState = NoteState.existingNote(note)
            router?.presentEventNote(noteState: noteState)
        } else {
            let noteState = NoteState.newNote(noteType ?? .gifts, event)
            router?.presentEventNote(noteState: noteState)
        }
    }
}

// MARK: - EventDetailsInteractorOutputting

extension EventDetailsPresenter: EventDetailsInteractorOutputting {
    
    func handleNotification(daysBefore: Int, timeOfDay: Date) {
        let content = EventDetailsView.Content(
            event: event,
            daysBefore: ReminderDaysBefore(rawValue: daysBefore),
            timeOfDay: timeOfDay,
            infoType: activeInfoType,
            noteType: activeNoteType
        )
        view?.setDetails(content: content)
    }
    
    func handleNotificationNotFound() {
        let content = EventDetailsView.Content(
            event: event,
            daysBefore: nil,
            timeOfDay: nil,
            infoType: activeInfoType,
            noteType: activeNoteType
        )
        view?.setDetails(content: content)
    }
}
