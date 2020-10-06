//
//  EventReminderViewModel.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/3/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import Foundation
import UserNotifications

enum EventReminderAction {
    case displayAlertCancel
    case displayAlertError
    case displayAlertPermissions
    case dismissView
}

class EventReminderViewModel {
    
    // MARK: Properties
    
    private let eventReminderDetails: EventReminderDetails
    private let notificationManager: NotificationManager
    
    private var notificationFound = false
    
    private var selectedTimeOfDayPicker: Foundation.Date {
        return selectedTimeOfDay.rounded(minutes: 15, rounding: .ceiling)
    }
    
    var selectedDaysBefore = 0
    var selectedTimeOfDay = Foundation.Date()
    
    private var selectedDaysBeforeString: String {
        return EventReminderDaysBefore(rawValue: selectedDaysBefore)?.pickerText ?? "?"
    }
    
    private var selectedTimeOfDayString: String {
        return selectedTimeOfDay.formatted("h:mm a")
    }
    
    var descriptionLabelText: String {
        return selectedDaysBeforeString + " at " + selectedTimeOfDayString
    }
    
    // MARK: Initialization
    
    init(eventReminderDetails: EventReminderDetails, notificationRequest: UNNotificationRequest?) {
        self.eventReminderDetails = eventReminderDetails
        self.notificationManager = NotificationManager(notificationRequest: notificationRequest)
        
        if notificationRequest != nil {
            self.notificationFound = true
        }
    }
    
    // MARK: Public Interface
    
    func generateContent() -> EventReminderView.Content {
        selectedDaysBefore = notificationManager.valueFor(key: "index") ?? selectedDaysBefore
        selectedTimeOfDay = notificationManager.triggerTime() ?? selectedTimeOfDay
        
        return EventReminderView.Content(
            selectedDaysBeforeIndex: selectedDaysBefore,
            selectedTimeOfDayDate: selectedTimeOfDayPicker,
            descriptionLabelText: descriptionLabelText,
            shouldShowCancelButton: notificationFound
        )
    }
    
    func cancelReminder() {
        let notificationIdentifier = eventReminderDetails.identifier
        notificationManager.cancelNotificationWith(identifier: notificationIdentifier)
    }
    
    func saveReminder(_ completion: @escaping (EventReminderAction, UNNotificationRequest?) -> Void) {
        notificationManager.permissionStatus { status in
            switch status {
            case .authorized:
                self.scheduleNotification {
                    completion(.dismissView, $0)
                }
            case .provisional:
                self.scheduleNotification {
                    completion(.dismissView, $0)
                }
            case .notDetermined:
                self.notificationManager.requestPermission { (success, error) in
                    if success {
                        self.scheduleNotification {
                            completion(.dismissView, $0)
                        }
                    } else {
                        completion(.displayAlertError, nil)
                    }
                }
            case .denied:
                completion(.displayAlertPermissions, nil)
            default:
                completion(.displayAlertError, nil)
            }
        }
    }
    
    private func scheduleNotification(_ completion: @escaping (UNNotificationRequest?) -> Void) {
        let notificationDetails = createNotificationDetails()
        
        notificationManager.scheduleNotification(with: notificationDetails) { notificationRequest in
            completion(notificationRequest)
        }
    }
    
    private func createNotificationDetails() -> NotificationDetails {
        let titlePrefix = eventReminderDetails.eventType.emoji
        let bodyPrefix = eventReminderDetails.eventType.rawValue
        
        let titleSuffix = eventReminderDetails.eventName
        let bodySuffix = EventReminderDaysBefore(rawValue: selectedDaysBefore)?.reminderText ?? "event is coming up... 👀"

        let title = [titlePrefix, titleSuffix].joined(separator: " ")
        let body = [bodyPrefix, bodySuffix].joined(separator: " ")
        
        let details = NotificationDetails(
            id: eventReminderDetails.identifier,
            title: title,
            body: body,
            daysBefore: selectedDaysBefore,
            dateComponents: generateFireDateComponents()
        )
        
        return details
    }
    
    private func generateFireDateComponents() -> DateComponents {
        let eventDateComponents = eventReminderDetails.eventDate.dateComponents
        
        let today = Foundation.Date()
        let monthAndDayOfEvent = DateComponents(month: eventDateComponents.month, day: eventDateComponents.day)
        
        let nextEventDate = Calendar.current.nextDate(
            after: today,
            matching: monthAndDayOfEvent,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .forward
        )
        
        let fireDateComponents = DateComponents(
            year: nextEventDate?.dateComponents.year,
            month: nextEventDate?.dateComponents.month,
            day: nextEventDate!.dateComponents.day! - selectedDaysBefore,
            hour: selectedTimeOfDay.dateComponents.hour,
            minute: selectedTimeOfDay.dateComponents.minute
        )

        return fireDateComponents
    }
}
