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
        notificationManager.retrieveNotification(for: id) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let notification):
                DispatchQueue.main.async {
                    strongSelf.presenter?.handleReminderFound(notification)
                }
            case .failure:
                return
            }
        }
    }
}
