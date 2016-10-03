//
//  CNContact+Name.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/2/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation
import Contacts

extension CNContact {

    var fullName: String {
        return givenName + " " + familyName
    }
    
    var abbreviatedName: String {
        guard let character = familyName.characters.first else { return givenName }
        return givenName + " " + String(character)
    }
    
    var postalAddress: CNPostalAddress? {
        return postalAddresses.filter({ address -> Bool in
            guard let label = address.label else { return false }
            return label.contains("Home")
        }).first?.value
    }
    
    var birthdate: Foundation.Date? {
        return birthday?.date ?? nil
    }
    
    var anniversary: Foundation.Date? {
        return dates.filter { date -> Bool in
            guard let label = date.label else { return false }
            return label.contains("Anniversary")
        }.first?.value.date
    }
}
