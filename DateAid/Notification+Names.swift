//
//  Notification+Names.swift
//  DateAid
//
//  Created by Aaron Williamson on 7/1/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

extension NSNotification.Name {

    /// A notification has been scheduled.
    static var NotificationScheduled: NSNotification.Name {
        return .init("ReminderSet")
    }
}
