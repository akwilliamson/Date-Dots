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
    
    func generateEditContent(for event: Date) -> EventSetupView.Content {
        firstNameText = event.firstName
        lastNameText = event.lastName
        addressOneText = event.address?.street
        addressTwoText = event.address?.region
        eventType = event.eventType
        eventDate = event.date
        
        return EventSetupView.Content(
            whoText: Constant.String.whoText,
            whatText: Constant.String.whatText,
            whenText: Constant.String.whenText,
            whereText: Constant.String.whereText,
            whyText: Constant.String.whyText,
            firstNameText: event.firstName,
            firstNamePlaceholderText: event.firstName == nil ? Constant.String.firstNamePlaceholderText : nil,
            lastNameText: event.lastName,
            lastNamePlaceholderText: event.lastName == nil ? Constant.String.lastNamePlaceholderText : nil,
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
    
    var activeEventSetupInputType: EventSetupInputType?
    
    var eventType: EventType?
    var eventDate: Foundation.Date?
    
    private var firstNameText: String?
    private var lastNameText: String?
    private var addressOneText: String?
    private var addressTwoText: String?
    
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
    
    private func placeholderTextForInputType(_ inputType: EventSetupInputType) -> String {
        switch inputType {
        case .firstName:  return Constant.String.firstNamePlaceholderText
        case .lastName:   return Constant.String.lastNamePlaceholderText
        case .addressOne: return Constant.String.addressOnePlaceholderText
        case .addressTwo: return Constant.String.addressTwoPlaceholderText
        }
    }
}
