//
//  EventDetailsInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/19/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

protocol EventDetailsInteractorInputting: AnyObject {
    
    func getReminder(with id: String)
}

class EventDetailsInteractor {

    // MARK: VIPER
    
    weak var presenter: EventDetailsInteractorOutputting?
    
    // MARK: Properties
    
    private let notificationManager = NotificationManager()
}

// MARK: EventDetailsInteractorInputting

extension EventDetailsInteractor: EventDetailsInteractorInputting {
    
    func getReminder(with id: String) {
        notificationManager.retrieveNotification(for: id) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let reminder):
                Dispatch.main {
                    strongSelf.presenter?.reminderFound(reminder)
                }
            case .failure:
                Dispatch.main {
                    strongSelf.presenter?.reminderNotFound()
                }
            }
        }
    }
}
