//
//  EventsEventHandling.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation

protocol EventsEventHandling: class {
    
    func viewDidLoad()
    func viewWillAppear()
    func eventsToShow() -> [Date]
    func searchButtonPressed()
    func textChanged(to searchText: String)
    func cancelButtonPressed()

    func dotPressed(for eventType: EventType)
    func deleteEventPressed(for event: Date, at indexPath: IndexPath)
}
