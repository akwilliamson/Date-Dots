//
//  EventsInteractorProtocol.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

protocol EventsInteractorInputting: class {
    
    func fetchEvents() -> Void
    func delete(_ event: Date)
}
