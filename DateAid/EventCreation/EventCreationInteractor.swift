//
//  EventCreationInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/25/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

protocol EventCreationInteractorInputting: AnyObject {
    
}

class EventCreationInteractor {
 
    weak var presenter: EventCreationInteractorOutputting?
}

// MARK: EventCreationInteractorInputting

extension EventCreationInteractor: EventCreationInteractorInputting {

}
