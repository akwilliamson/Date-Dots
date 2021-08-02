//
//  EventCreationInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/25/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import CoreData
import Foundation

protocol EventCreationInteractorInputting: AnyObject {

    func findReminder(for event: Event)
    func saveReminder(_ reminder: Reminder)
    func saveEvent(_ event: Event)
    func deleteEvent(_ event: Event)
}

class EventCreationInteractor {
    
    // MARK: VIPER
 
    weak var presenter: EventCreationInteractorOutputting?
    
    // MARK: Properties
    
    private let notificationManager = NotificationManager()
}

// MARK: - EventCreationInteractorInputting

extension EventCreationInteractor: EventCreationInteractorInputting {
    
    func findReminder(for event: Event) {
        notificationManager.retrieveNotification(for: event.id) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let reminder):
                strongSelf.presenter?.handleEventReminder(reminder: reminder)
            case .failure(let error):
                print(error.localizedDescription)
                strongSelf.presenter?.handleEventReminder(reminder: nil)
            }
        }
    }
    
    func saveEvent(_ event: Event) {
        do {
            try CoreDataManager.save()
            presenter?.eventSaveSucceeded(event: event)
        } catch {
            presenter?.eventSaveFailed(error: error)
        }
    }
    
    func deleteEvent(_ event: Event) {
        do {
            try CoreDataManager.delete(object: event)
            notificationManager.removeNotification(with: event.id)
            presenter?.eventDeleteSucceeded()
        } catch {
            presenter?.eventDeleteFailed(error: error)
        }
    }
    
    func saveReminder(_ reminder: Reminder) {
        notificationManager.removeNotification(with: reminder.id)
        
        notificationManager.scheduleNotification(reminder: reminder) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success:
                print("foo")
//                strongSelf.presenter?.reminderSaveSucceeded(reminder: reminder)
            case .failure:
                print("bar")
//                strongSelf.presenter?.reminderSaveFailed(error: error)
            }
        }
    }
}
