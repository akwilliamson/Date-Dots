//
//  Reminder.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/29/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

/// The details needed to schedule a reminder notification for an event.
struct Reminder {
    /// The unique ID of the reminder
    let id: String
    /// The title text of the reminder
    let title: String
    /// The body text of the reminder
    let body: String
    /// The date to be reminded
    let fireDate: DateComponents
}
