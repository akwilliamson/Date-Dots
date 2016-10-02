//
//  Date+CoreDataProperties.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/21/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Date {

    @NSManaged var abbreviatedName: String?
    @NSManaged var date: Foundation.Date?
    @NSManaged var equalizedDate: String?
    @NSManaged var name: String?
    @NSManaged var type: String?
    @NSManaged var address: Address?
    @NSManaged var notes: NSSet?

}
