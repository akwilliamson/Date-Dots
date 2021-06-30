//
//  EventCreationManager.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/19/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import CoreData

/// Manages the setting and retrieving of properties on an `Event`.
struct EventCreationManager {
    
    // MARK: Private Properties
    
    private var context = CoreDataManager.shared.viewContext
    private(set) var event: Event
    
    // MARK: Public Properties
    
    var eventType: EventType {
        return event.eventType
    }
    
    var eventDate: Date {
        return event.date
    }
    
    var firstName: String {
        return event.givenName
    }
    
    var lastName: String {
        return event.familyName
    }
    
    var street: String {
        return event.address?.street ?? String()
    }
    
    var region: String {
        return event.address?.region ?? String()
    }
    
    // MARK: Initialization
    
    init(event: Event?) {
        if let event = event {
            self.event = event
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Event", in: context)!
            self.event = Event(entity: entity, insertInto: context)
        }
    }
    
    // MARK: Public Methods
    
    func setEventType(_ eventType: EventType) {
        event.type = eventType.rawValue
    }
    
    func setEventDate(_ date: Date) {
        event.date = date
    }
    
    func setFirstName(_ name: String) {
        event.givenName = name
    }
    
    func setLastName(_ name: String) {
        event.familyName = name
    }
    
    func setStreet(_ street: String) {
        if event.address == nil  {
            addAddress()
        }
        event.address?.street = street
    }
    
    func setRegion(_ region: String) {
        if event.address == nil  {
            addAddress()
        }
        event.address?.region = region
    }
    
    // MARK: Private Helpers
    
    private func addAddress() {
        let entity = NSEntityDescription.entity(forEntityName: "Address", in: context)!
        event.address = Address(entity: entity, insertInto: context)
    }
}
