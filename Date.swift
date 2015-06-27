//
//  Date.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/26/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation
import CoreData

class Date: NSManagedObject {

    @NSManaged var abbreviatedName: String
    @NSManaged var            date: NSDate
    @NSManaged var   equalizedDate: String
    @NSManaged var            name: String
    @NSManaged var            type: String
    
}
