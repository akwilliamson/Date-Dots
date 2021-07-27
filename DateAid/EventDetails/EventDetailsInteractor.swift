//
//  EventDetailsInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/19/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

protocol EventDetailsInteractorInputting: AnyObject {}

class EventDetailsInteractor {

    // MARK: VIPER
    
    weak var presenter: EventDetailsInteractorOutputting?
    
    // MARK: Properties
    
    private let notificationManager = NotificationManager()
}

// MARK: EventDetailsInteractorInputting

extension EventDetailsInteractor: EventDetailsInteractorInputting {}
