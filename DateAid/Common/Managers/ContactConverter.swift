//
//  ContactConverter.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/2/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Contacts
import CoreData

class ContactConverter {

    private var contacts: [CNContact] = []
    
    init(contacts: [CNContact]) {
        self.contacts = contacts
    }

    public func syncEvents() {
        
        createBirthdays()
        createAnniversaries()
        createHolidays()
        
        try? CoreDataManager.save()
    }
    
    private func createBirthdays() {
        contacts.forEach { contact in
            if contact.birthday != nil { event(for: contact, of: .birthday) }
        }
    }
    
    private func createAnniversaries() {
        contacts.forEach { contact in
            if contact.anniversary != nil { event(for: contact, of: .anniversary) }
        }
    }
    
    private func createHolidays() {
        guard let path = Bundle.main.path(forResource: "Holidays", ofType: "plist"),
        let dict = NSDictionary(contentsOfFile: path) as? [String: Date] else {
            return
        }

        let storedEvents: [Event]

        do {
            storedEvents = try CoreDataManager.fetch()
        } catch {
            storedEvents = []
            print(error.localizedDescription)
        }
        
        for (givenName, givenDate) in dict {
        
            let exists = storedEvents.contains { $0.name == givenName && $0.type == EventType.custom.rawValue }
            
            if !exists {
                let event = Event(context: CoreDataManager.shared.viewContext)
                // Deprecated
                event.name            = "DEPRECATED"
                event.abbreviatedName = "DEPRECATED"
                event.equalizedDate   = "DEPRECATED"
                event.givenName       = givenName
                event.familyName      = String()
                event.date            = givenDate
                event.type            = EventType.custom.rawValue
            }
        }
    }
    
    private func event(for contact: CNContact?, of type: EventType) {
        
        let storedEvents: [Event]
        
        do {
            try storedEvents = CoreDataManager.fetch()
        } catch {
            storedEvents = []
        }
        
        let exists = storedEvents.contains { $0.name == contact?.fullName && $0.type == type.rawValue }
        
        if !exists {
            if let entity = NSEntityDescription.entity(forEntityName: "Date", in: CoreDataManager.shared.viewContext),
                let contact = contact {
                
                let event = Event(entity: entity, insertInto: CoreDataManager.shared.viewContext)
                
                event.type = type.rawValue
                // Deprecated
                event.name = contact.fullName
                
                switch type {
                case .birthday:
                    let birthdate = contact.birthdate ?? Date() // TODO: default to something smarter
                    event.date = birthdate
                case .anniversary:
                    let anniversaryDate = contact.anniversary ?? Date() // TODO: default to something smarter
                    event.date = anniversaryDate
                case .custom:
                    return // TODO: Fix later
                case .other:
                    return // TODO: Fix later
                }
                
                if let address = contact.postalAddress {
                    event.address = create(address, for: event)
                }
            }
        }
        
    }
    
    private func create(_ postalAddress: CNPostalAddress, for event: Event) -> Address? {
        
        if let entity = NSEntityDescription.entity(forEntityName: "Date", in: CoreDataManager.shared.viewContext) {
            let address = Address(entity: entity, insertInto: CoreDataManager.shared.viewContext)
            address.event = event
            address.street = postalAddress.street
            address.region = "\(postalAddress.city) \(postalAddress.state), \(postalAddress.postalCode)"
            return address
        } else {
            return nil
        }
    }
}
