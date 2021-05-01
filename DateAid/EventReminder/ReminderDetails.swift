//
//  ReminderDetails.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/9/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UserNotifications

/// The Details Required to set a local notification reminder.
struct ReminderDetails {
    /// The notification identifier
    var identifier: String
    /// The name of the event
    var eventName: String
    /// The type of the event
    var eventType: EventType
    /// The date of the event
    var eventDate: Date
    /// The days remaining until the event
    var daysRemaining: Int
}
