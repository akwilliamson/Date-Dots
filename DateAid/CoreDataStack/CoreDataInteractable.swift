//
//  CoreDataInteractable.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/30/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

/// Has access to an NSManagedObjectContext for Core Data interactions.
protocol CoreDataInteractable {
    /// The accessible managed object context
    var moc: NSManagedObjectContext { get }
}

extension CoreDataInteractable {
    
    var moc: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).moc
    }
}
