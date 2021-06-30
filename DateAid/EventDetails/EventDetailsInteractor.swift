//
//  EventDetailsInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/19/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UserNotifications

protocol EventDetailsInteractorInputting: AnyObject {
    
    func getReminder(for id: String)
}

class EventDetailsInteractor {

    // MARK: VIPER
    
    weak var presenter: EventDetailsInteractorOutputting?
    
    // MARK: Properties
    
    private let notificationManager = NotificationManager()
}

// MARK: EventDetailsInteractorInputting

extension EventDetailsInteractor: EventDetailsInteractorInputting {
    
    func getReminder(for id: String) {
        notificationManager.retrieveNotification(for: id) { result in
            switch result {
            case .success(let notification):
                if
                    let dayPrior = notification.content.userInfo["DaysPrior"] as? Int,
                    let trigger = notification.trigger as? UNCalendarNotificationTrigger,
                    let triggerDate = trigger.nextTriggerDate()
                {
                    self.presenter?.handleNotification(dayPrior: dayPrior, timeOfDay: triggerDate)
                }
            case .failure:
                self.presenter?.handleNotification(dayPrior: nil, timeOfDay: nil)
            }
        }
    }
}
