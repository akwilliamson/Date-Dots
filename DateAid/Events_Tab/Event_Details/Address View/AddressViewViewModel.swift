//
//  AddressViewViewModel.swift
//  Date Dots
//
//  Created by Aaron Williamson on 4/29/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class AddressViewViewModel {
    
    // MARK: Initialization
    
    init(address: Address?, eventType: EventType) {
        self.address = address
        self.eventType = eventType
    }
    
    // MARK: Private Properties
    
    private var address: Address?
    private var eventType: EventType
    
    // MARK: Public Properties

    var addressText: String {
        return address?.street ?? "Address"
    }
    
    var addressColor: UIColor {
        return address?.street == nil ? .compatibleLabel : eventType.color
    }
    
    var addressFont: UIFont {
        return address?.street == nil ? UIFont(name: "AvenirNext-DemiBold", size: 18)! : UIFont(name: "Noteworthy-Bold", size: 20)!
    }
    
    var regionText: String {
        return address?.region ?? "City, State, Zip"
    }
    
    var regionColor: UIColor {
        return address?.region == nil ? .compatibleLabel : eventType.color
    }
    
    var regionFont: UIFont {
        return address?.region == nil ? UIFont(name: "AvenirNext-DemiBold", size: 18)! : UIFont(name: "Noteworthy-Bold", size: 20)!
    }
    
    public func setAddress(address: Address?) {
        self.address = address
    }
    
    public func setEventType(eventType: EventType) {
        self.eventType = eventType
    }
}
