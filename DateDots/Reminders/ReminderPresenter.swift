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
    func didSelectWeeksPrior(_ weeksPrior: Int)
    func didSelectDaysPrior(_ daysPrior: Int)
    func didChangeTimeOfDay(_ date: Date)
    func didPressSaveReminder()
    func didPressDeleteReminder()
    func didConfirmDeleteReminder()
}

protocol ReminderInteractorOutputting: AnyObject {
    
    func reminderSaveFailed(error: NotificationError)
    func reminderSaveSucceeded(reminder: UNNotificationRequest)
    func reminderDeleted()
    func eventSaved()
}

class ReminderPresenter {
    
    // MARK: VIPER
    
    weak var router: ReminderRouter?
    var view: ReminderViewOutputting?
    var interactor: ReminderInteractorInputting?
    
    // MARK: Constants
    
    private enum Constant {
        static let navigationTitle = "Reminder"
    }
    
    // MARK: Properties
    
    private let userDefaultsManager = UserDefaultsManager()
    
    private var event: Event
    private var reminder: UNNotificationRequest?
    
    private var fireDateComponents: DateComponents
    
    // MARK: Computed Properties
    
    private var eventDaysFromNow: Int {
        return Calendar.current.days(from: Date(), to: event.date)
    }
    
    private var eventDaysFromFireDate: Int {
        return Calendar.current.days(from: fireDateComponents.date!, to: event.date)
    }
    
    private var reminderTitle: String {
        "\(event.eventType.emoji) \(event.abvName)"
    }
    
    private var reminderBody: String {
        guard let fireDate = fireDateComponents.date else { return "is soon" }
        
        let daysAway = Calendar.current.days(from: fireDate, to: event.date)
        switch daysAway {
        case 0:  return "\(event.eventType.rawValue) is today"
        case 1:  return "\(event.eventType.rawValue) is tomorrow"
        default: return "\(event.eventType.rawValue) is \(daysAway) days away"
        }
    }
    
    private var scheduleText: String {
        let fireDate = Calendar.current.date(from: fireDateComponents)
        
        let day = CalendarManager().daysBetween(triggerDate: fireDate!, eventDate: event.date)
        
        let time = fireDateComponents.date!.formatted("h:mm a")
        
        switch day {
        case 0:  return "Day of at \(time)"
        case 1:  return "\(day) day before at \(time)"
        case 7:  return "1 week before at \(time)"
        case 14: return "2 weeks before at \(time)"
        case 21: return "3 weeks before at \(time)"
        default:
            return "\(day) days before at \(time)"
        }
    }
    
    // MARK: Initialization

    init(details: ReminderDetails) {
        self.event = details.event
        self.reminder = details.reminder
        
        if
            let trigger = reminder?.trigger as? UNCalendarNotificationTrigger,
            let triggerDate = trigger.nextTriggerDate()
        {
            self.fireDateComponents = DateComponents(
                calendar: .current,
                timeZone: .current,
                year: triggerDate.year,
                month: triggerDate.month,
                day: triggerDate.day,
                hour: triggerDate.hour,
                minute: triggerDate.minute
            )
            
        } else {
            var triggerYear: Int?
            
            if
                let eventMonth = event.date.month,
                let eventDay = event.date.day,
                let thisMonth = Date().month,
                let today = Date().day
            {
                if eventMonth < thisMonth {
                    triggerYear = Date().year! + 1
                } else if eventMonth == thisMonth && eventDay < today {
                    triggerYear = Date().year! + 1
                } else {
                    triggerYear = Date().year
                }
            } else {
                triggerYear = Date().year
            }
            
            self.fireDateComponents = DateComponents(
                calendar: .current,
                timeZone: .current,
                year: triggerYear,
                month: event.date.month,
                day: event.date.day,
                hour: Date().hour,
                minute: Date().rounded(minutes: 15, rounding: .floor).minute
            )
        }
    }
}

// MARK: - ReminderEventHandling

extension ReminderPresenter: ReminderEventHandling {
    
    func viewDidLoad() {
        view?.configureNavigation(title: Constant.navigationTitle)
        if reminder != nil {
            view?.configureNavigationDeleteButton()
            view?.populateView(
                content: ReminderView.Content(
                    scheduleText: scheduleText,
                    eventColor: event.eventType.color,
                    eventDaysFromNow: eventDaysFromNow,
                    eventDaysFromFireDate: eventDaysFromFireDate,
                    fireDate: fireDateComponents.date!,
                    isScheduled: true
                )
            )
        } else {
            view?.configureNavigationSaveButton()
            view?.populateView(
                content: ReminderView.Content(
                    scheduleText: scheduleText,
                    eventColor: event.eventType.color,
                    eventDaysFromNow: eventDaysFromNow,
                    eventDaysFromFireDate: eventDaysFromFireDate,
                    fireDate: fireDateComponents.date!,
                    isScheduled: false
                )
            )
        }
    }
    
    func didSelectWeeksPrior(_ weeksPrior: Int) {
        setEventReminder(weeksPrior: weeksPrior)
        updateReminder()
        view?.didUpdateSchedule(text: scheduleText)
    }
    
    func didSelectDaysPrior(_ daysPrior: Int) {
        setEventReminder(daysPrior: daysPrior)
        updateReminder()
        view?.didUpdateSchedule(text: scheduleText)
    }
    
    func didChangeTimeOfDay(_ date: Date) {
        setEventReminder(from: date)
        updateReminder()
        view?.didUpdateSchedule(text: scheduleText)
    }
    
    private func updateReminder() {
        guard reminder != nil else { return }
        interactor?.updateReminder(
            Reminder(
                id: event.id,
                title: reminderTitle,
                body: reminderBody,
                fireDate: fireDateComponents
            )
        )
    }
    
    func didPressSaveReminder() {
        interactor?.saveReminder(
            Reminder(
                id: event.id,
                title: reminderTitle,
                body: reminderBody,
                fireDate: fireDateComponents
            )
        )
    }
    
    func didPressDeleteReminder() {
        view?.presentAlertWillDelete(
            title: "Confirm Delete",
            body: "This reminder will be permanently deleted.",
            confirm: "Confirm",
            dismiss: "Cancel"
        )
    }
    
    func didConfirmDeleteReminder() {
        interactor?.deleteReminder(for: event.id)
    }
    
    // MARK: Private Methods
    
    private func setEventReminder(weeksPrior: Int) {
        let daysPrior = weeksPrior * 7
        let date = Calendar.current.date(byAdding: .day, value: -daysPrior, to: event.date)!
        fireDateComponents.month = date.month
        fireDateComponents.day = date.day
    }

    private func setEventReminder(daysPrior: Int) {
        let date = Calendar.current.date(byAdding: .day, value: -daysPrior, to: event.date)!
        fireDateComponents.month = date.month
        fireDateComponents.day = date.day
    }
    
    private func setEventReminder(from date: Date) {
        fireDateComponents.hour = date.hour
        fireDateComponents.minute = date.minute
    }
}

// MARK: - ReminderInteractorOutputting

extension ReminderPresenter: ReminderInteractorOutputting {

    func reminderSaveFailed(error: NotificationError) {
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
    
    func reminderSaveSucceeded(reminder: UNNotificationRequest) {
        self.reminder = reminder
        event.hasReminder = true
        userDefaultsManager.bumpInt(for: .countReminderSave)
        interactor?.saveEvent()
    }
    
    func reminderDeleted() {
        self.reminder = nil
        event.hasReminder = false
        interactor?.saveEvent()
    }
    
    func eventSaved() {
        router?.dismiss()
    }
}
