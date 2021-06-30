//
//  ReminderPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/20/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UserNotifications

protocol ReminderEventHandling: AnyObject {
    
    func viewDidLoad()
    func didSelectDayPrior(_ dayPrior: Int)
    func didChangeTimeOfDay(_ date: Date)
    func didPressSaveReminder()
    func didPressDeleteReminder()
    func didConfirmDeleteReminder()
}

protocol ReminderInteractorOutputting: AnyObject {
    
    func handleReminderNotFound()
    func handleReminderFound(_ notification: UNNotificationRequest)
    func handleReminderSaved()
    func handleReminderNotSaved(error: NotificationError)
    func handleReminderDeleted()
}

class ReminderPresenter {
    
    // MARK: VIPER
    
    weak var router: ReminderRouter?
    var view: ReminderViewOutputting?
    var interactor: ReminderInteractorInputting?
    
    // MARK: Constants
    
    private enum Constant {
        enum String {
            static let navigationTitle = "Reminder"
            static let barButtonTitle = "Save"
        }
    }
    
    // MARK: Properties
    
    private let event: Event
    
    // Event Values
    private var daysUntilEvent = 365
    private var title = ""
    private var body = ""
    // Notification Values
    private var dayPrior: ReminderDayPrior = .zero
    private var timeOfDay = Date()
    
    private var scheduledText: String {
        let timeText = timeOfDay.rounded(minutes: 15, rounding: .ceiling).formatted("h:mm a")
        
        switch dayPrior {
        case .zero: return "Day of at \(timeText)"
        case .one:  return "\(dayPrior.rawValue) day before at \(timeText)"
        default:    return "\(dayPrior.rawValue) days before at \(timeText)"
        }
    }
    
    private var timeOfDayComponents: DateComponents {
        Calendar.current.dateComponents(in: .current, from: timeOfDay)
    }
    
    // MARK: Initialization

    init(event: Event) {
        self.event = event
        setEventValues(from: event)
    }
}

// MARK: - ReminderEventHandling

extension ReminderPresenter: ReminderEventHandling {
    
    func viewDidLoad() {
        view?.configureNavigation(title: Constant.String.navigationTitle)
        view?.configureNavigationButton(title: Constant.String.barButtonTitle)
        interactor?.getReminder(for: event.id)
    }
    
    func didSelectDayPrior(_ dayPrior: Int) {
        setDayPrior(dayPrior)
        view?.didUpdateScheduled(text: scheduledText)
    }
    
    func didChangeTimeOfDay(_ date: Date) {
        setTimeOfDay(date)
        view?.didUpdateScheduled(text: scheduledText)
    }
    
    func didPressSaveReminder() {
        interactor?.saveReminder(
            Reminder(
                id: event.id,
                title: title,
                body: body,
                dayPrior: dayPrior.rawValue,
                fireDate: timeOfDayComponents
            )
        )
    }
    
    func didPressDeleteReminder() {
        view?.presentAlertWillDelete(
            title: "Confirm Delete",
            body: "Are you sure you want to delete this reminder?",
            confirm: "Confirm",
            dismiss: "Dismiss"
        )
    }
    
    func didConfirmDeleteReminder() {
        interactor?.deleteReminder(for: event.id)
    }
    
    // MARK: Private Methods
    
    private func setEventValues(from event: Event) {
        
        self.daysUntilEvent = Calendar.current.daysUntil(event: event.date)
        
        self.title = "\(event.eventType.emoji) \(event.abvName)"
        
        switch daysUntilEvent {
        case 0:
            self.body = "\(event.eventType.rawValue) is today"
        case 1:
            self.body = "\(event.eventType.rawValue) is tomorrow"
        default:
            self.body = "\(event.eventType.rawValue) is \(daysUntilEvent) days away"
        }
    }
    
    private func setNotificationValues(from notification: UNNotificationRequest) {
        if let dayPrior = notification.content.userInfo["DaysPrior"] as? Int {
           setDayPrior(dayPrior)
        }
        
        if
            let trigger = notification.trigger as? UNCalendarNotificationTrigger,
            let triggerDate = trigger.nextTriggerDate()
        {
            setTimeOfDay(triggerDate)
        }
    }
    
    private func setDayPrior(_ dayPrior: Int) {
        self.dayPrior = ReminderDayPrior(rawValue: dayPrior) ?? self.dayPrior
    }
    
    private func setTimeOfDay(_ date: Date) {
        self.timeOfDay = date
    }
}

// MARK: - ReminderInteractorOutputting

extension ReminderPresenter: ReminderInteractorOutputting {
    
    func handleReminderNotFound() {
        view?.populateView(
            content: ReminderView.Content(
                eventColor: event.eventType.color,
                daysUntilEvent: daysUntilEvent,
                dayPrior: dayPrior,
                timeOfDay: timeOfDay,
                isScheduled: false,
                scheduledText: scheduledText
            )
        )
    }
    
    func handleReminderFound(_ notification: UNNotificationRequest) {
        setNotificationValues(from: notification)
        
        view?.populateView(
            content: ReminderView.Content(
                eventColor: event.eventType.color,
                daysUntilEvent: daysUntilEvent,
                dayPrior: dayPrior,
                timeOfDay: timeOfDay,
                isScheduled: true,
                scheduledText: scheduledText
            )
        )
    }
    
    func handleReminderNotSaved(error: NotificationError) {
        switch error {
        case .accessDenied, .denied:
            view?.presentAlertErrorAuth(
                title: "Access Denied",
                body: "Notification permissions must be enabled in your settings.",
                confirm: "Visit Settings",
                dismiss: "Dismiss"
            )
        case .schedulingFailed, .unknown:
            view?.presentAlertErrorSave(
                title: "Uh Oh...",
                body: "Something went wrong. Please try again.",
                dismiss: "Dismiss"
            )
            
        default:
            return
        }
    }
    
    func handleReminderSaved() {
        router?.dismiss()
    }
    
    func handleReminderDeleted() {
        router?.dismiss()
    }
}
