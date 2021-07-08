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

    func saveEvent(_ event: Event)
    func deleteEvent(_ event: Event)
}

class EventCreationInteractor {
    
    // MARK: VIPER
 
    weak var presenter: EventCreationInteractorOutputting?
}

// MARK: - EventCreationInteractorInputting

extension EventCreationInteractor: EventCreationInteractorInputting {
    
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
            presenter?.eventDeleteSucceeded()
        } catch {
            presenter?.eventDeleteFailed(error: error)
        }
    }
}
