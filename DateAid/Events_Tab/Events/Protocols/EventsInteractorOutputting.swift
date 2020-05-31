//
//  EventsPresenterInteractorProtocol.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

protocol EventsInteractorOutputting: class {
    
    func eventsFetched(_ events: [Date])
    func eventsFetchedFailed(_ error: EventsInteractorError)
    func eventDeleted(_ event: Date)
    func eventDeleteFailed(_ error: EventsInteractorError)
}
