//
//  Date.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/15/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class Event: NSManagedObject {

    // Deprecated
    @NSManaged var abbreviatedName: String
    // Deprecated
    @NSManaged var name: String
    // Deprecated
    @NSManaged var equalizedDate: String
    
    @NSManaged var type: String
    @NSManaged var date: Date
    @NSManaged var hasReminder: Bool
    @NSManaged var givenName: String
    @NSManaged var familyName: String
    @NSManaged var address: Address?
    @NSManaged var notes: Set<Note>?
    
    var id: String {
        return objectID.uriRepresentation().absoluteString
    }
    
    var formattedDate: String {
        date.formatted("MM/dd")
    }
    
    public var eventType: EventType {
        switch type {
        case "birthday":    return .birthday
        case "anniversary": return .anniversary
        case "custom":      return .custom
        case "holiday":     return .custom
        case "other":       return .other
        default:            return .birthday
        }
    }

    public func note(forType noteType: NoteType) -> Note? {
        guard let notes = notes else { return nil }

        return Array(notes).filter { $0.type.lowercased() == noteType.rawValue.lowercased() }.first
    }
}

// MARK: - EventNaming

extension Event: EventNaming {}

// MARK: - EventAging

extension Event: EventAging {}
