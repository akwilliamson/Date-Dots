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
    
    func didSelectEdit()
    func didSelectAddress()
    func didSelectReminder()
    func didSelect(infoType: InfoType)
    func didSelect(noteType: NoteType)
    func didSelect(note: Note?, noteType: NoteType?)
}

protocol EventDetailsInteractorOutputting: AnyObject {
    
    func reminderFound(_ reminder: UNNotificationRequest)
    func reminderNotFound()
}

protocol EventDetailsUpdating: AnyObject {
    
    func handleUpdated(event: Event)
}

class EventDetailsPresenter {
    
    // MARK: VIPER
    
    weak var router: EventDetailsRouter?
    var view: EventDetailsViewOutputting?
    var interactor: EventDetailsInteractorInputting?
    
    // MARK: Constants
    
    private enum Constant {
        static let keyPrefix = "eventdetails-"
    }
    
    // MARK: Properties
    
    private let userDefaultsManager = UserDefaultsManager()
    
    private var event: Event
    private var reminder: UNNotificationRequest?
    
    // MARK: Computed Properties
    
    private var activeInfoType: InfoType {
        [.reminder, .address].filter {
            userDefaultsManager.getBool(type: $0.rawValue, for: .displayInfo)
        }.first ?? .reminder
    }
    
    private var activeNoteType: NoteType {
        return [.gifts, .plans, .misc].filter {
            userDefaultsManager.getBool(type: $0.rawValue, for: .displayNote)
        }.first ?? .gifts
    }
    
    // MARK: Initialization
    
    init(eventDetails: EventDetails) {
        self.event = eventDetails.event
        self.reminder = eventDetails.reminder
    }
    
    // MARK: Private Helpers
    
    private func setPreferenceFor(infoType: InfoType) {
        userDefaultsManager.setBool(false, type: InfoType.address.rawValue, for: .displayInfo)
        userDefaultsManager.setBool(false, type: InfoType.reminder.rawValue, for: .displayInfo)
        userDefaultsManager.setBool(true, type: infoType.rawValue, for: .displayInfo)
        
        switch infoType {
        case .address:
            UserDefaults.standard.set(false, forKey: "\(Constant.keyPrefix)\(InfoType.reminder.key)")
        case .reminder:
            UserDefaults.standard.set(true, forKey: "\(Constant.keyPrefix)\(InfoType.reminder.key)")
        }
    }
    
    private func setPreferenceFor(noteType: NoteType) {
        userDefaultsManager.setBool(false, type: NoteType.gifts.rawValue, for: .displayNote)
        userDefaultsManager.setBool(false, type: NoteType.plans.rawValue, for: .displayNote)
        userDefaultsManager.setBool(false, type: NoteType.misc.rawValue, for: .displayNote)
        userDefaultsManager.setBool(true, type: noteType.rawValue, for: .displayNote)
    }
}

// MARK: - EventDetailsEventHandling

extension EventDetailsPresenter: EventDetailsEventHandling {
    
    func viewDidLoad() {}
    
    func viewWillAppear() {
        view?.configureNavigation(title: "\(event.eventType.emoji) \(event.abvName)")
        interactor?.getReminder(with: event.id)
        view?.populateView(
            content: EventDetailsView.Content(
                event: event,
                scheduleText: nil,
                infoType: activeInfoType,
                noteType: activeNoteType
            )
        )
        
        let saveReminderCount = userDefaultsManager.getInt(for: .countReminderSave)

        if saveReminderCount % 10 == 0 {
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
    
    func didSelectEdit() {
        router?.presentEventCreation(event: event)
    }
    
    func didSelectAddress() {
        router?.presentEventCreation(event: event)
    }
    
    func didSelectReminder() {
        let details = ReminderDetails(event: event, reminder: reminder)
        router?.presentEventReminder(details: details)
    }
    
    func didSelect(infoType: InfoType) {
        setPreferenceFor(infoType: infoType)
        view?.select(infoType: activeInfoType)
    }
    
    func didSelect(noteType: NoteType) {
        setPreferenceFor(noteType: noteType)
        view?.select(noteType: activeNoteType)
    }
    
    func didSelect(note: Note?, noteType: NoteType?) {
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
    
    func reminderFound(_ reminder: UNNotificationRequest) {
        guard
            let trigger = reminder.trigger as? UNCalendarNotificationTrigger,
            let triggerDate = trigger.nextTriggerDate()
        else {
            return
        }
        self.reminder = reminder
        
        let reminderText = generateReminderText(for: triggerDate)
        view?.updateReminder(text: reminderText)
    }
    
    func reminderNotFound() {
        self.reminder = nil
        
        let reminderText = "Add\nReminder"
        view?.updateReminder(text: reminderText)
    }
    
    private func generateReminderText(for date: Date) -> String {

        let dateComponents = DateComponents(
            calendar: .current,
            timeZone: .current,
            year: date.year,
            month: date.month,
            day: date.day,
            hour: date.hour,
            minute: date.minute
        )
        
        let day = CalendarManager().daysBetween(triggerDate: date, eventDate: event.date)
        
        let time = dateComponents.date!.formatted("h:mm a")
        
        switch day {
        case 0:  return "Day of\nat \(time)"
        case 1:  return "\(day) day befor\nat \(time)"
        case 7:  return "1 week before\nat \(time)"
        case 14: return "2 weeks before\nat \(time)"
        case 21: return "3 weeks before\nat \(time)"
        default:
            return "\(day) days before\nat \(time)"
        }
    }
}

extension EventDetailsPresenter: EventDetailsUpdating {
    
    func handleUpdated(event: Event) {
        self.event = event
        view?.configureNavigation(title: "\(event.eventType.emoji) \(event.abvName)")
        view?.populateView(
            content: EventDetailsView.Content(
                event: event,
                scheduleText: nil,
                infoType: activeInfoType,
                noteType: activeNoteType
            )
        )
    }
}
