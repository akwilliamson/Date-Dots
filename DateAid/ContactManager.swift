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
    
    let store = CNContactStore()
    var contacts: [CNContact?] {
        return getContacts()
    }
    
    private func getContacts() -> [CNContact?] {
        
        var fetchedContacts: [CNContact?] = []
        
        authorized(complete: { success in
            if success {
                fetchedContacts = self.fetchContacts()
            }
        })
        return fetchedContacts
    }
    
    private func fetchContacts() -> [CNContact?] {
        
        let keys: [CNKeyDescriptor] = [
            CNContactGivenNameKey       as CNKeyDescriptor,
            CNContactFamilyNameKey      as CNKeyDescriptor,
            CNContactBirthdayKey        as CNKeyDescriptor,
            CNContactDatesKey           as CNKeyDescriptor
        ]
        do {
            let containerId = CNContactStore().defaultContainerIdentifier()
            let predicate: NSPredicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
            return try CNContactStore().unifiedContacts(matching: predicate, keysToFetch: keys)
            // contacts.forEach({ print("\n\($0.givenName) \($0.familyName): \($0.birthday)\n\($0.dates.first?.label): \($0.dates.first?.value.date)\n****\n") })
        } catch let error {
            print("error: \(error)")
            return []
        }
    }
    
    private func authorized(complete: @escaping (_ success: Bool) -> Void) {
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            complete(true)
        case .notDetermined:
            store.requestAccess(for: .contacts, completionHandler: { (success, error) in
                return success ? complete(true) : complete(false)
            })
        case .restricted, .denied:
            return complete(false)
        }
    }
}
