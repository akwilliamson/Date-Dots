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

    @NSManaged var abbreviatedName: String?
    @NSManaged var date: Date?
    @NSManaged var equalizedDate: String?
    @NSManaged var name: String?
    @NSManaged var type: String?
    @NSManaged var address: Address?
    @NSManaged var notes: Set<Note>?
    
    var objectIDString: String {
        return objectID.uriRepresentation().absoluteString
    }
    
    public var firstName: String? {
        return name?.components(separatedBy: " ").first
    }
    
    public var lastName: String? {
        return name?.components(separatedBy: " ").last
    }
    
    public var eventType: EventType {
        guard let type = type else { return .other }

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

        return Array(notes).filter { $0.type == noteType.title.lowercased() }.first
    }
}
