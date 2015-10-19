//
//  Address+CoreDataProperties.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/19/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Address {

    @NSManaged var street: String?
    @NSManaged var city: String?
    @NSManaged var state: String?
    @NSManaged var zip: NSNumber?
    @NSManaged var date: Date?

}
