//
//  Date.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/15/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation
import CoreData

class Date: NSManagedObject {

    @NSManaged var abbreviatedName: String?
    @NSManaged var date: Foundation.Date?
    @NSManaged var equalizedDate: String?
    @NSManaged var name: String?
    @NSManaged var type: String?
    @NSManaged var address: Address?
    @NSManaged var notes: NSSet?
    
    public var firstName: String? {
        return name?.components(separatedBy: " ").first
    }
    
    public var lastName: String? {
        return name?.components(separatedBy: " ").last
    }
    
    // TODO: REMOVE
    var color: UIColor {
        
        guard let type = self.type else { return .birthday }
    
        switch type.lowercased() {
        case "birthday":    return UIColor.birthday
        case "anniversary": return UIColor.anniversary
        case "holiday":     return UIColor.holiday
        default:            return UIColor.custom
        }
    }
    
    public var dateType: DateType {
        guard let type = type else { return .other }

        switch type {
        case "Birthday":    return .birthday
        case "Anniversary": return .anniversary
        case "Custom":      return .holiday
        case "Other":       return .other
        default:            return .other
        }
    }
}
