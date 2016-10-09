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
    
    var firstName: String? {
        return name?.components(separatedBy: " ").first
    }
    
    var lastName: String? {
        return name?.components(separatedBy: " ").last
    }
    
    var color: UIColor {
        
        guard let type = self.type else { return UIColor.birthday }
    
        switch type.lowercased() {
        case "birthday":
            return UIColor.birthday
        case "anniversary":
            return UIColor.anniversary
        case "custom":
            return UIColor.custom
        default:
            return UIColor.birthday
        }
        
    }
    
}
