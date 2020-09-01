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

    private var daysBeforePickerOptions: [String] {
        return [
            EventReminderWindow.dayOf.pickerText,
            EventReminderWindow.oneDay.pickerText,
            EventReminderWindow.twoDays.pickerText,
            EventReminderWindow.threeDays.pickerText,
            EventReminderWindow.fourDays.pickerText,
            EventReminderWindow.fiveDays.pickerText,
            EventReminderWindow.sixDays.pickerText,
            EventReminderWindow.sevenDays.pickerText
        ]
    }
    
    private var selectedTimeOfDayPicker: Foundation.Date {
        return selectedTimeOfDayDate.rounded(minutes: 15, rounding: .ceiling)
    }
    
    var selectedDaysBeforeIndex = 0
    var selectedTimeOfDayDate = Foundation.Date()
    
    var descriptionLabelText: String {
        return selectedDaysBeforeText + " at " + selectedTimeOfDayText
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
        selectedDaysBeforeIndex = notificationManager.valueFor(key: "index") ?? selectedDaysBeforeIndex
        selectedTimeOfDayDate = notificationManager.triggerTime() ?? selectedTimeOfDayDate
        
        return EventReminderView.Content(
            daysBeforePickerOptions: self.daysBeforePickerOptions,
            selectedDaysBeforeIndex: self.selectedDaysBeforeIndex,
            selectedTimeOfDayDate: self.selectedTimeOfDayPicker,
            descriptionLabelText: self.descriptionLabelText,
            shouldShowCancelButton: self.notificationFound
        )
    }
    
    func cancelReminder() {
        let notificationIdentifier = eventReminderDetails.identifier
        notificationManager.cancelNotificationWith(identifier: notificationIdentifier)
    }
    
    func saveReminder(_ completion: @escaping (EventReminderAction, UNNotificationRequest?) -> Void) {
        notificationManager.permissionStatus { status in
            switch status {
            case .authorized, .provisional:
                let notificationDetails = self.createNotificationDetails()
                self.notificationManager.scheduleNotification(with: notificationDetails) { notificationRequest in
                    completion(.dismissView, notificationRequest)
                }
            case .notDetermined:
                self.notificationManager.requestPermission { (success, error) in
                    if success {
                        let notificationDetails = self.createNotificationDetails()
                        self.notificationManager.scheduleNotification(with: notificationDetails) { notificationRequest in
                            completion(.dismissView, notificationRequest)
                        }
                    } else {
                        completion(.displayAlertError, nil)
                    }
                }
            case .denied:
                completion(.displayAlertPermissions, nil)
            @unknown default:
                completion(.displayAlertError, nil)
            }
        }
    }
    
    private func createNotificationDetails() -> NotificationDetails {
        let title: String
        let body: String
        
        let reminderText = EventReminderWindow(rawValue: selectedDaysBeforeIndex)?.reminderText ?? "event is coming up"

        switch eventReminderDetails.eventType {
        case .birthday:
            title = "🎈 \(eventReminderDetails.eventName) "
            body = "birthday \(reminderText)"
        case .anniversary:
            title = "💞 \(eventReminderDetails.eventName)"
            body = "anniversary \(reminderText)"
        case .holiday:
            title = "🎉 \(eventReminderDetails.eventName)"
            body = "holiday \(reminderText)"
        case .other:
            title = "💡 \(eventReminderDetails.eventName)"
            body = "event \(reminderText)"
        }
        
        let details = NotificationDetails(
            id: eventReminderDetails.identifier,
            title: title,
            body: body,
            index: selectedDaysBeforeIndex,
            dateComponents: generateReminderDateComponents()
        )
        
        return details
    }
    
    private func generateReminderDateComponents() -> DateComponents {
        
        let eventDateComponents = DateComponents(
            month: eventReminderDetails.eventDate.components.month,
            day: eventReminderDetails.eventDate.components.day
        )
        
        let nextEventDate = Calendar.current.nextDate(
            after: Foundation.Date(),
            matching: eventDateComponents,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .forward
        )
        
        let fireDateComponents = DateComponents(
            year: nextEventDate?.components.year,
            month: nextEventDate?.components.month,
            day: nextEventDate?.components.day,
            hour: selectedTimeOfDayDate.components.hour,
            minute: selectedTimeOfDayDate.components.minute
        )

        return fireDateComponents
    }
    
    // MARK: Private Helpers
    
    private var selectedDaysBeforeText: String {
        daysBeforePickerOptions[selectedDaysBeforeIndex]
    }
    
    private var selectedTimeOfDayText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: selectedTimeOfDayDate)
    }
}
