        //
//  ReminderInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/20/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UserNotifications

protocol ReminderInteractorInputting: AnyObject {
    
    func saveReminder(_ reminder: Reminder)
    func deleteReminder(for id: String)
}

class ReminderInteractor {
    
    // MARK: VIPER
    
    weak var presenter: ReminderInteractorOutputting?
    
    // MARK: Properties
    
    private let notificationManager = NotificationManager()
}

// MARK: - ReminderInteractorInputting

extension ReminderInteractor: ReminderInteractorInputting {
 
    func saveReminder(_ reminder: Reminder) {
        notificationManager.scheduleNotification(reminder: reminder) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success:
                strongSelf.presenter?.handleReminderSaved()
            case .failure(let error):
                strongSelf.presenter?.handleReminderNotSaved(error: error)
            }
        }
    }
    
    func deleteReminder(for id: String) {
        notificationManager.removeNotification(with: id)
        presenter?.handleReminderDeleted()
    }
}
