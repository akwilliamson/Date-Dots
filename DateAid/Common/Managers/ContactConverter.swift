//
//  ContactConverter.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/2/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation
import Contacts
import CoreData

class ContactConverter: CoreDataInteractable {

    private var contacts: [CNContact] = []
    
    init(contacts: [CNContact]) {
        self.contacts = contacts
    }

    public func syncEvents() {
        
        createBirthdays()
        createAnniversaries()
        createHolidays()
        
        try? moc.save()
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
        let dict = NSDictionary(contentsOfFile: path) as? [String: Foundation.Date] else {
            return
        }

        let storedEvents: [Date]

        do {
            storedEvents = try moc.fetch()
        } catch {
            storedEvents = []
            print(error.localizedDescription)
        }
        
        for (givenName, givenDate) in dict {
        
            let exists = storedEvents.contains { $0.name == givenName && $0.type == EventType.holiday.rawValue }
            
            if !exists {
                if let entity = NSEntityDescription.entity(forEntityName: "Date", in: moc) {
                    let date = Date(entity: entity, insertInto: moc)
                    date.type            = EventType.holiday.rawValue
                    date.name            = givenName
                    date.abbreviatedName = givenName
                    date.date            = givenDate
                    date.equalizedDate   = givenDate.formatted("MM/dd")
                }
            }
        }
    }
    
    private func event(for contact: CNContact?, of type: EventType) {
        
        let storedEvents: [Date]
        
        do {
            try storedEvents = moc.fetch()
        } catch {
            storedEvents = []
        }
        
        let exists = storedEvents.contains { $0.name == contact?.fullName && $0.type == type.rawValue }
        
        if !exists {
            if let entity = NSEntityDescription.entity(forEntityName: "Date", in: moc),
                let contact = contact {
                
                let event = Date(entity: entity, insertInto: moc)
                
                event.type            = type.rawValue
                event.name            = contact.fullName
                event.abbreviatedName = contact.abbreviatedName
                
                switch type {
                case .birthday:
                    event.date            = contact.birthdate
                    event.equalizedDate   = contact.birthdate?.formatted("MM/dd")
                case .anniversary:
                    event.date            = contact.anniversary
                    event.equalizedDate   = contact.anniversary?.formatted("MM/dd")
                case .holiday:
                    return // Fix later
                case .other:
                    return // Fix later
                }
                
                if let address = contact.postalAddress {
                    event.address = create(address, for: event)
                }
            }
        }
        
    }
    
    private func create(_ postalAddress: CNPostalAddress, for event: Date) -> Address? {
        
        if let entity = NSEntityDescription.entity(forEntityName: "Date", in: moc) {
            let address = Address(entity: entity, insertInto: moc)
            address.date = event
            address.street = postalAddress.street
            address.region = "\(postalAddress.city) \(postalAddress.state), \(postalAddress.postalCode)"
            return address
        } else {
            return nil
        }
    }
}
