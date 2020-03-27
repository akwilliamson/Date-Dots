//
//  ContactManager.swift
//  DateAid
//
//  Created by Aaron Williamson on 9/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation
import Contacts

class ContactManager {
    
    static var store = CNContactStore()
    
    static func syncContacts(complete: @escaping () -> Void) {
        
        authorized(complete: { success in
            let fetchedContacts: [CNContact] = success ? self.fetchContacts() : []
            fetchedContacts.forEach({ print($0.givenName) })
            DateManager(contacts: fetchedContacts).syncDates()
            
            complete()
        })
    }
    
    static func authorized(complete: @escaping (_ success: Bool) -> Void) {
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            complete(true)
        case .notDetermined:
            store.requestAccess(for: .contacts, completionHandler: { (success, error) in
                return success ? complete(true) : complete(false)
            })
        case .restricted:
            return complete(false)
        case .denied:
            return complete(false)
        @unknown default:
            return complete(false)
        }
    }
    
    static func fetchContacts() -> [CNContact] {
        
        let keys: [CNKeyDescriptor] = [
            CNContactGivenNameKey       as CNKeyDescriptor,
            CNContactFamilyNameKey      as CNKeyDescriptor,
            CNContactBirthdayKey        as CNKeyDescriptor,
            CNContactDatesKey           as CNKeyDescriptor,
            CNContactPostalAddressesKey as CNKeyDescriptor,
        ]
        
        do {
            let containerId = store.defaultContainerIdentifier()
            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
            return try store.unifiedContacts(matching: predicate, keysToFetch: keys)
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
}
