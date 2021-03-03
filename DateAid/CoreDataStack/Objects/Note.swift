//
//  Note.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/21/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation
import CoreData

class Note: NSManagedObject {

    @NSManaged var subject: String?
    @NSManaged var body: String?
    @NSManaged var type: String?
    @NSManaged var event: Event?
}
