//
//  DateSetupViewModel.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/4/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class DateSetupViewModel {
    
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
    
    let content = DateSetupView.Content(
        whoText: Constant.String.whoText,
        whatText: Constant.String.whatText,
        whenText: Constant.String.whenText,
        whereText: Constant.String.whereText,
        whyText: Constant.String.whyText,
        firstNamePlaceholderText: Constant.String.firstNamePlaceholderText,
        lastNamePlaceholderText: Constant.String.lastNamePlaceholderText,
        addressOnePlaceholderText: Constant.String.addressOnePlaceholderText,
        addressTwoPlaceholderText: Constant.String.addressTwoPlaceholderText,
        whyDescriptionText: Constant.String.whyDescriptionText
    )
    
    // MARK: Properties
    
    var showPlaceholderText = false
    
    // MARK: Methods
    
    func placeholderPropertiesFor(editing: Bool) -> (text: String?, textColor: UIColor) {
        let placeholderText: String?
        let textColor: UIColor
        
        showPlaceholderText = editing ? false : true
        placeholderText =     editing ? nil   : "asdf"
        textColor =           editing ? .red  : .blue

        return (placeholderText, textColor)
    }
}
