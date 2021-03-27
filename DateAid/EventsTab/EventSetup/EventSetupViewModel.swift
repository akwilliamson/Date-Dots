//
//  EventSetupViewModel.swift
//  Date Dots
//
//  Created by Aaron Williamson on 5/4/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class EventSetupViewModel {
    
    // MARK: Constants
    
    private enum Constant {
        enum Key {
            static let daysBefore = "DaysBefore"
        }
        enum String {
            static let whoText = "Who"
            static let whatText = "What"
            static let whenText = "When"
            static let whereText = "Where"
            static let whyText = "Why"
            static let firstNamePlaceholderText = "First Name"
            static let lastNamePlaceholderText = "Last Name"
            static let addressOnePlaceholderText = "Address 1"
            static let addressTwoPlaceholderText = "Address 2"
            static let whyDescriptionText = "Because you care!"
            static let eventIsComingUp = "event is coming up... 👀"
        }
    }
    
    // MARK: Content
    
    func generateAddContent() -> EventSetupView.Content {
        return EventSetupView.Content(
            whoText: Constant.String.whoText,
            whatText: Constant.String.whatText,
            whenText: Constant.String.whenText,
            whereText: Constant.String.whereText,
            whyText: Constant.String.whyText,
            firstNameText: nil,
            firstNamePlaceholderText: Constant.String.firstNamePlaceholderText,
            lastNameText: nil,
            lastNamePlaceholderText: Constant.String.lastNamePlaceholderText,
            addressOneText: nil,
            addressOnePlaceholderText: Constant.String.addressOnePlaceholderText,
            addressTwoText: nil,
            addressTwoPlaceholderText: Constant.String.addressTwoPlaceholderText,
            whyDescriptionText: Constant.String.whyDescriptionText,
            date: nil,
            eventType: nil
        )
    }
    
    func generateEditContent(for event: Event) -> EventSetupView.Content {
        firstNameText = event.givenName
        lastNameText = event.familyName
        addressOneText = event.address?.street
        addressTwoText = event.address?.region
        eventType = event.eventType
        eventDate = event.date
        eventId = event.objectIDString
        notificationManager = NotificationManager()
        notificationManager.notification(with: event.objectIDString) { existingNotificationRequest in
            self.existingNotificationRequest = existingNotificationRequest
        }
        
        return EventSetupView.Content(
            whoText: Constant.String.whoText,
            whatText: Constant.String.whatText,
            whenText: Constant.String.whenText,
            whereText: Constant.String.whereText,
            whyText: Constant.String.whyText,
            firstNameText: event.givenName,
            firstNamePlaceholderText: nil,
            lastNameText: event.familyName,
            lastNamePlaceholderText: event.familyName.isEmpty ? Constant.String.lastNamePlaceholderText : nil,
            addressOneText: event.address?.street,
            addressOnePlaceholderText: event.address?.street == nil ? Constant.String.addressOnePlaceholderText : nil,
            addressTwoText: event.address?.region,
            addressTwoPlaceholderText: event.address?.region == nil ? Constant.String.addressTwoPlaceholderText : nil,
            whyDescriptionText: Constant.String.whyDescriptionText,
            date: event.date,
            eventType: event.eventType
        )
    }
    
    // MARK: Properties
    
    var eventId: String?
    var eventType: EventType?
    var eventDate: Date?
    
    private var firstNameText: String?
    private var lastNameText: String?
    private var addressOneText: String?
    private var addressTwoText: String?
    private var activeEventSetupInputType: EventSetupInputType?
    
    private var notificationManager = NotificationManager()
    private var existingNotificationRequest: UNNotificationRequest?
    
    // Deprecated
    var eventName: String? {
        if let firstNameText = firstNameText, !firstNameText.isEmpty, let lastNameText = lastNameText, !lastNameText.isEmpty {
            let firstName = firstNameText.trimmingCharacters(in: .whitespaces)
            let lastName = lastNameText.trimmingCharacters(in: .whitespaces)
            return "\(firstName) \(lastName)"
        } else if let firstNameText = firstNameText, !firstNameText.isEmpty {
            return firstNameText.trimmingCharacters(in: .whitespaces)
        } else {
            return nil
        }
    }
    
    // Deprecated
    var eventNameAbbreviated: String? {
        if let firstNameText = firstNameText, !firstNameText.isEmpty, let lastNameInitial = lastNameText?.first {
            let firstName = firstNameText.trimmingCharacters(in: .whitespaces)
            return "\(firstName) \(String(lastNameInitial))"
        } else if let firstNameText = firstNameText, !firstNameText.isEmpty {
            return firstNameText.trimmingCharacters(in: .whitespaces)
        } else {
            return nil
        }
    }
    
    var givenName: String? {
        if let firstName = firstNameText, !firstName.isEmpty {
            return firstName.trimmingCharacters(in: .whitespaces)
        } else {
            return nil
        }
    }
    
    var familyName: String {
        if let lastName = lastNameText, !lastName.isEmpty {
            return lastName.trimmingCharacters(in: .whitespaces)
        } else {
            return String()
        }
    }
    
    var eventAddressOne: String? {
        if let addressOneText = addressOneText, !addressOneText.isEmpty {
            return addressOneText.trimmingCharacters(in: .whitespaces)
        } else {
            return nil
        }
    }
    
    var eventAddressTwo: String? {
        if let addressTwoText = addressTwoText, !addressTwoText.isEmpty {
            return addressTwoText.trimmingCharacters(in: .whitespaces)
        } else {
            return nil
        }
    }
    
    var eventDateString: String? {
        return eventDate?.formatted("MM/dd")
    }
    
    // MARK: Methods
    
    func inputValuesFor(_ inputType: EventSetupInputType, currentText: String?, isEditing: Bool) -> (text: String?, textColor: UIColor) {
        activeEventSetupInputType = isEditing ? inputType : nil
        setValueFor(inputType: inputType, currentText: currentText)

        if isEditing {
            if currentText == placeholderTextForInputType(inputType) {
                return (nil, .compatibleLabel)
            } else {
                return (currentText, .compatibleLabel)
            }
        } else {
            if currentText.isEmptyOrNil {
                return (placeholderTextForInputType(inputType), .compatiblePlaceholderText)
            } else {
                return (currentText, .compatibleLabel)
            }
        }
    }
    
    func adjustedViewHeight(willShow: Bool, yOrigin: CGFloat, for notification: NSNotification) -> CGFloat {
        guard
            let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            activeEventSetupInputType == .some(.addressOne) || activeEventSetupInputType == .some(.addressTwo)
        else {
            return 0
        }

        if willShow {
            if yOrigin < 0 {
                // The keyboard is already showing, don't modify the origin
                return 0
            } else {
                // The keyboard is not showing, modify the origin
                return -keyboardSize.cgRectValue.height
            }
        } else {
            if yOrigin < 0 {
                // The keyboard is already showing, modify the origin
                return keyboardSize.cgRectValue.height
            } else {
                // The keyboard is not showing, don't modify the origin
                return 0
            }
        }
    }
    
    func setValueFor(inputType: EventSetupInputType, currentText: String?) {
        switch inputType {
        case .firstName:  firstNameText = currentText
        case .lastName:   lastNameText = currentText
        case .addressOne: addressOneText = currentText
        case .addressTwo: addressTwoText = currentText
        }
    }
    
    func rescheduleNotificationIfNeeded(completion:  @escaping () -> Void) {
        if
            let existingNotificationRequest = existingNotificationRequest,
            let triggerDate = existingNotificationRequest.trigger as? UNCalendarNotificationTrigger,
            let daysBeforeIndex: Int = notificationManager.valueFor(key: Constant.Key.daysBefore),
            let daysBefore = EventReminderDaysBefore(rawValue: daysBeforeIndex)?.rawValue,
            let eventType = eventType,
            let eventName = eventName
        {
            notificationManager.cancelNotificationWith(identifier: existingNotificationRequest.identifier)

            let titlePrefix = eventType.emoji
            let titleSuffix = eventName
            let title = [titlePrefix, titleSuffix].joined(separator: " ")
            
            let bodyPrefix = eventType.rawValue
            let bodySuffix = EventReminderDaysBefore(rawValue: daysBefore)?.reminderText ?? Constant.String.eventIsComingUp
            let body = [bodyPrefix, bodySuffix].joined(separator: " ")
            
            let dateComponents = generateFireDateComponents(triggerDate.dateComponents, daysBefore: daysBefore)
            
            let details = NotificationDetails(
                id: existingNotificationRequest.identifier,
                title: title,
                body: body,
                daysBefore: daysBefore,
                dateComponents: dateComponents
            )
            
            notificationManager.scheduleNotification(with: details) { newNotificationRequest in
                completion()
            }
        } else {
            completion()
        }
    }
    
    private func generateFireDateComponents(_ dateComponents: DateComponents, daysBefore: Int) -> DateComponents {
        guard let eventDate = eventDate else {
            return dateComponents
        }
        
        let eventMonth = eventDate.month
        let eventDay = eventDate.day
        
        let today = Foundation.Date()
        let monthAndDayOfEvent = DateComponents(month: eventMonth, day: eventDay)
        
        let nextEventDate = Calendar.current.nextDate(
            after: today,
            matching: monthAndDayOfEvent,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .forward
        )
        
        let fireDateComponents = DateComponents(
            year: nextEventDate?.year,
            month: nextEventDate?.month,
            day: nextEventDate!.day! - daysBefore,
            hour: dateComponents.hour,
            minute: dateComponents.minute
        )

        return fireDateComponents
    }
    
    private func placeholderTextForInputType(_ inputType: EventSetupInputType) -> String {
        switch inputType {
        case .firstName:  return Constant.String.firstNamePlaceholderText
        case .lastName:   return Constant.String.lastNamePlaceholderText
        case .addressOne: return Constant.String.addressOnePlaceholderText
        case .addressTwo: return Constant.String.addressTwoPlaceholderText
        }
    }
}
