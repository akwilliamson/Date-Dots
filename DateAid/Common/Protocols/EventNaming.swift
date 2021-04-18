//
//  EventNaming.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/10/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

protocol EventNaming {
    // Deprecated
    var name: String { get }
    
    var givenName: String { get }
    var familyName: String { get }
    
    var fullName: String { get }
    var abvName: String { get }
}

extension EventNaming {
    
    // CNContact does not have a `name` property, but conforms to `EventNaming` for the free values below
    var name: String {
        return String()
    }
    
    var fullName: String {
        return "\(givenName) \(familyName)"
    }
    
    var abvName: String {
        if let familyAbbreviation = familyName.first {
            return "\(givenName) \(String(familyAbbreviation))"
        } else {
            return "\(givenName) "
        }
    }
}
