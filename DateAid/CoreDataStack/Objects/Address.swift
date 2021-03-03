//
//  Address.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/19/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation
import CoreData

class Address: NSManagedObject {

    @NSManaged var street: String?
    @NSManaged var region: String?
    @NSManaged var event: Event?
}
