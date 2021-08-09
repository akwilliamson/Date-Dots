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
        default: return "\(day) days before at \(time)"
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
    
    func didSelectDayPrior(_ dayPrior: Int) {
        setDateComponentDays(dayPrior: dayPrior)
        if reminder != nil {
            interactor?.updateReminder(
                Reminder(
                    id: event.id,
                    title: reminderTitle,
                    body: reminderBody,
                    fireDate: fireDateComponents
                )
            )
        }
        view?.didUpdateSchedule(text: scheduleText)
    }
    
    func didChangeTimeOfDay(_ date: Date) {
        setDateComponentTime(from: date)
        if reminder != nil {
            interactor?.updateReminder(
                Reminder(
                    id: event.id,
                    title: reminderTitle,
                    body: reminderBody,
                    fireDate: fireDateComponents
                )
            )
        }
        view?.didUpdateSchedule(text: scheduleText)
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
    
    private func setDateComponents(from date: Date) {
        fireDateComponents.day = date.day
        fireDateComponents.hour = date.hour
        fireDateComponents.minute = date.minute
    }
    
    private func setDateComponentDays(dayPrior: Int) {
        guard let eventDay = event.date.day else { return }
        if eventDay > 7 {
            fireDateComponents.day = eventDay - dayPrior
        } else {
            let notificationDay = eventDay - dayPrior
            
            if notificationDay > 0 {
                fireDateComponents.day = notificationDay
                fireDateComponents.month = event.date.month
            } else {
                if fireDateComponents.month != event.date.month! - 1 {
                    fireDateComponents.month = event.date.month! - 1
                }
                let daysToSubtractFromPreviousMonth = abs(notificationDay)
                
                switch fireDateComponents.month {
                case 1, 3, 5, 7, 8, 10, 12:
                    fireDateComponents.day = 31 - daysToSubtractFromPreviousMonth
                case 2:
                    if Date().year! % 4 == 0 {
                        fireDateComponents.day = 29 - daysToSubtractFromPreviousMonth
                    } else {
                        fireDateComponents.day = 28 - daysToSubtractFromPreviousMonth
                    }
                case 4, 6, 9, 11:
                    fireDateComponents.day = 30 - daysToSubtractFromPreviousMonth
                default:
                    fireDateComponents.day = notificationDay
                }
            }
        }
        print(fireDateComponents)
    }
    
    private func setDateComponentDays(from date: Date) {
        fireDateComponents.day = date.day
    }
    
    private func setDateComponentTime(from date: Date) {
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
