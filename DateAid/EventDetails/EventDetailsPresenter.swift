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
    
    func handleReminderFound(_ notification: UNNotificationRequest)
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
    
    private var event: Event
    private var notification: UNNotificationRequest?
    
    // MARK: Computed Properties
    
    private var activeInfoType: InfoType {
        let key = "\(Constant.keyPrefix)\(InfoType.reminder.key)"
        return UserDefaults.standard.bool(forKey: key) ? .reminder : .address
    }
    
    private var activeNoteType: NoteType {
        return [.gifts, .plans, .misc].filter {
            UserDefaults.standard.bool(forKey: "\(Constant.keyPrefix)\($0.key)")
        }.first ?? .gifts
    }
    
    // MARK: Initialization
    
    init(event: Event) {
        self.event = event
        NotificationCenter.default.addObserver(self, selector: #selector(reminderSet(_:)), name: .NotificationScheduled, object: nil)
    }
    
    // MARK: Notifications
    
    @objc
    func reminderSet(_ notification: Notification) {
        guard let notificationRequest = notification.userInfo?["request"] as? UNNotificationRequest else { return }
        
        DispatchQueue.main.async {
            self.handleReminderFound(notificationRequest)
        }
    }
    
    // MARK: Private Helpers
    
    private func setPreferenceFor(infoType: InfoType) {
        switch infoType {
        case .address:
            UserDefaults.standard.set(false, forKey: "\(Constant.keyPrefix)\(InfoType.reminder.key)")
        case .reminder:
            UserDefaults.standard.set(true, forKey: "\(Constant.keyPrefix)\(InfoType.reminder.key)")
        }
    }
    
    private func setPreferenceFor(noteType: NoteType) {
        UserDefaults.standard.set(false, forKey: "\(Constant.keyPrefix)\(NoteType.gifts.key)")
        UserDefaults.standard.set(false, forKey: "\(Constant.keyPrefix)\(NoteType.plans.key)")
        UserDefaults.standard.set(false, forKey: "\(Constant.keyPrefix)\(NoteType.misc.key)")
        UserDefaults.standard.set(true,  forKey: "\(Constant.keyPrefix)\(noteType.key)")
    }
}

// MARK: - EventDetailsEventHandling

extension EventDetailsPresenter: EventDetailsEventHandling {
    
    func viewDidLoad() {
        view?.configureNavigation(title: "\(event.eventType.emoji) \(event.abvName)")
        view?.populateView(
            content: EventDetailsView.Content(
                event: event,
                scheduleText: nil,
                infoType: activeInfoType,
                noteType: activeNoteType
            )
        )
        interactor?.getReminder(for: event.id)
    }
    
    func viewWillAppear() {}
    
    func didSelectEdit() {
        router?.presentEventEdit(event: event)
    }
    
    func didSelectAddress() {
        router?.presentEventEdit(event: event)
    }
    
    func didSelectReminder() {
        let details = ReminderDetails(event: event, notification: notification)
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
    
    func handleReminderFound(_ notification: UNNotificationRequest) {
        guard
            let trigger = notification.trigger as? UNCalendarNotificationTrigger,
            let triggerDate = trigger.nextTriggerDate()
        else {
            return
        }
        
        self.notification = notification
        
        let reminderText = generateReminderText(for: triggerDate)
        view?.updateReminder(text: reminderText)
    }
    
    private func generateReminderText(for date: Date) -> String {

        let dateComponents = DateComponents(
            calendar: .current,
            timeZone: .current,
            year: Date().year,
            month: event.date.month,
            day: date.day,
            hour: date.hour,
            minute: date.minute
        )
        
        let day = event.date.day! - date.day!
        let time = dateComponents.date!.formatted("h:mm a")
        
        switch day {
        case 0:  return "Day of\nat \(time)"
        case 1:  return "\(day) day before\nat \(time)"
        default: return "\(day) days before\nat \(time)"
        }
    }
}
