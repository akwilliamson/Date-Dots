//
//  Date.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/21/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation
import CoreData

class Date: NSManagedObject {

    @NSManaged var type: String
    @NSManaged var name: String
    @NSManaged var date: NSDate

}
