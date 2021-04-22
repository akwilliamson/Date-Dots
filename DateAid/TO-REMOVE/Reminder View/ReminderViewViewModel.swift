//
//  ReminderViewViewModel.swift
//  Date Dots
//
//  Created by Aaron Williamson on 4/29/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit
import UserNotifications

class ReminderViewViewModel {
    
    // MARK: Constants
    
    private enum Constant {
        enum Key {
            static let daysBefore = "DaysBefore"
        }
        enum String {
            static let reminderNotSet = "Reminder\nNot Set"
        }
        enum Color {
            static let reminder: UIColor = .compatibleLabel
        }
    }
    
    // MARK: Properties
    
    private let notificationManager = NotificationManager()
    
    // MARK: Private Interface
    
    private var reminderDayText: String? {
        guard
            let daysBeforeIndex: Int = notificationManager.valueFor(key: Constant.Key.daysBefore),
            let daysBefore = ReminderDaysBefore(rawValue: daysBeforeIndex)
        else {
            return nil
        }
        
        return daysBefore.pickerText
    }

    private var reminderTimeText: String? {
        guard let triggerTime = notificationManager.triggerTime() else { return nil }

        return triggerTime.formatted("h:mm a")
    }
    
    // MARK: Public Interface
    
    /// The font of the text displayed within a `ReminderView`.
    var reminderFont: UIFont {
        let fontSize: CGFloat
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            fontSize = 14
        default:
            fontSize = 18
        }

        return notificationManager.notificationExists ? FontType.noteworthyBold(fontSize).font : FontType.avenirNextDemiBold(fontSize).font
    }
    
    var reminderColor: UIColor {
        return Constant.Color.reminder
    }
    
    /// The text displayed within a `ReminderView`.
    var reminderText: String {
        guard
            let dayText = reminderDayText,
            let timeText = reminderTimeText
        else {
            return Constant.String.reminderNotSet
        }
        
        return "\(dayText)\n at \(timeText)"
    }
    
    /// Retrieves the notification request
    func getNotificationRequest() -> UNNotificationRequest? {
        notificationManager.getNotificationRequest()
    }
    
    /// Updates the notification request managed by the notification manager.
    func updateNotificationRequest(_ notificationRequest: UNNotificationRequest) {
        notificationManager.setNotificationRequest(notificationRequest)
    }
    
    /// Removes the notification request managed by the notification manager.
    func clearNotificationRequest() {
        notificationManager.clearNotificationRequest()
    }
}
