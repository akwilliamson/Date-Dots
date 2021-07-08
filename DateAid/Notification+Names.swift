//
//  Notification+Names.swift
//  DateAid
//
//  Created by Aaron Williamson on 7/1/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    
    /// An event has been created or updated and successfully saved.
    static var EventSaved: NSNotification.Name {
        return .init("EventSaved")
    }
}
