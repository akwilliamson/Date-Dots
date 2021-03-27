//
//  CNContact+Name.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/2/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation
import Contacts

extension CNContact: EventNaming {
    
    private enum Constant {
        enum String {
            static let home = "Home"
            static let anniversary = "Anniversary"
        }
    }
    
    var postalAddress: CNPostalAddress? {
        let possibleHomeAddress = postalAddresses.filter { address in
            guard let label = address.label else {
                return false
            }
            
            return label.contains(Constant.String.home)
        }
        
        return possibleHomeAddress.first?.value
    }
    
    var birthdate: Date? {
        var birthdayDateComponents = birthday
        birthdayDateComponents?.timeZone = .current
        
        return birthdayDateComponents?.date
    }
    
    var anniversary: Date? {
        let possibleAnniversary = dates.filter { date in
            guard let label = date.label else {
                return false
            }

            return label.contains(Constant.String.anniversary)
        }
        
        guard let anniversaryComponents = possibleAnniversary.first?.value else { return nil }
        
        var anniversary = anniversaryComponents as DateComponents
        anniversary.timeZone = .current
        
        return anniversary.date
    }
}
