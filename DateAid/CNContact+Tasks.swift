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
        guard let character = familyName.first else { return givenName }
        return givenName + " " + String(character)
    }
    
    var postalAddress: CNPostalAddress? {
        return postalAddresses.filter({ address -> Bool in
            guard let label = address.label else { return false }
            return label.contains("Home")
        }).first?.value
    }
    
    var birthdate: Foundation.Date? {
        var comps = birthday
        
        comps?.timeZone = TimeZone.current
        return comps?.date ?? nil
    }
    
    var anniversary: Foundation.Date? {
        let comps = dates.filter { date -> Bool in
            guard let label = date.label else { return false }
            return label.contains("Anniversary")
        }
        
        guard let components = comps.first?.value else { return nil }
        
        var finalComps = components as DateComponents

        finalComps.timeZone = TimeZone.current
        return finalComps.date
    }
}
