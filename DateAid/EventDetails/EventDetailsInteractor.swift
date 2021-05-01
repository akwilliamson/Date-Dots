//
//  EventDetailsInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/19/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

protocol EventDetailsInteractorInputting: AnyObject {
    
    func fetchNotification(id: String)
}

class EventDetailsInteractor {
    
    // MARK: Constants
    
    private enum Constant {
        enum Key {
            static let daysBefore = "DaysBefore"
        }
    }
    
    // MARK: Properties
    
    private let notificationManager = NotificationManager()
    
    weak var presenter: EventDetailsInteractorOutputting?
}

extension EventDetailsInteractor: EventDetailsInteractorInputting {
    
    func fetchNotification(id: String) {
        notificationManager.notification(with: id) { foundNotification in
            guard
                let daysBefore: Int = self.notificationManager.valueFor(key: Constant.Key.daysBefore),
                let timeOfDay = self.notificationManager.triggerTime()
            else {
                self.presenter?.handleNotificationNotFound()
                return
            }

            self.presenter?.handleNotification(daysBefore: daysBefore, timeOfDay: timeOfDay)
        }
    }
}
