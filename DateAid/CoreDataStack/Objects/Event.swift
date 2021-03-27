//
//  Date.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/15/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class Event: NSManagedObject, EventNaming {

    // Deprecated
    @NSManaged var abbreviatedName: String
    // Deprecated
    @NSManaged var name: String
    
    @NSManaged var givenName: String
    @NSManaged var familyName: String
    @NSManaged var date: Date
    @NSManaged var equalizedDate: String
    @NSManaged var type: String
    @NSManaged var address: Address?
    @NSManaged var notes: Set<Note>?
    
    var objectIDString: String {
        return objectID.uriRepresentation().absoluteString
    }
    
    public var eventType: EventType {
        switch type {
        case "birthday":    return .birthday
        case "anniversary": return .anniversary
        case "custom":      return .holiday
        case "other":       return .other
        default:            return .other
        }
    }

    public func note(forType noteType: NoteType) -> Note? {
        guard let notes = notes else { return nil }

        return Array(notes).filter { $0.type.lowercased() == noteType.title.lowercased() }.first
    }
}
