//
//  Date.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/15/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class Date: NSManagedObject {

    @NSManaged var abbreviatedName: String?
    @NSManaged var date: Foundation.Date?
    @NSManaged var equalizedDate: String?
    @NSManaged var name: String?
    @NSManaged var type: String?
    @NSManaged var address: Address?
    @NSManaged var notes: Set<Note>?
    
    public var firstName: String? {
        return name?.components(separatedBy: " ").first
    }
    
    public var lastName: String? {
        return name?.components(separatedBy: " ").last
    }
    
    // TODO: REMOVE
    var color: UIColor {
        guard let type = self.type else { return DateType.birthday.color }
    
        switch type.lowercased() {
        case "birthday":    return DateType.birthday.color
        case "anniversary": return DateType.anniversary.color
        case "holiday":     return DateType.holiday.color
        default:            return DateType.other.color
        }
    }
    
    public var dateType: DateType {
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

        return Array(notes).filter { $0.title == noteType.title }.first
    }
}
