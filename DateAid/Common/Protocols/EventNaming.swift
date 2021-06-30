//
//  EventNaming.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/10/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

protocol EventNaming {
    
    var givenName: String  { get }
    var familyName: String { get }
    
    var fullName: String   { get }
    var abvName: String    { get }
}

extension EventNaming {
    
    var fullName: String {
        return "\(givenName) \(familyName)"
    }
    
    var abvName: String {
        guard let familyNameFirstLetter = familyName.first else {
            return givenName
        }
        
        return "\(givenName) \(String(familyNameFirstLetter))"
    }
}
