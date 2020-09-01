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
        return address?.street == nil ? FontType.avenirNextDemiBold(18).font : FontType.noteworthyBold(20).font
    }
    
    var regionText: String {
        return address?.region ?? "City, State, Zip"
    }
    
    var regionColor: UIColor {
        return address?.region == nil ? .compatibleLabel : eventType.color
    }
    
    var regionFont: UIFont {
        return address?.region == nil ? FontType.avenirNextDemiBold(18).font : FontType.noteworthyBold(20).font
    }
    
    // MARK: Public Methods
    
    public func updateAddress(address: Address?) {
        self.address = address
    }
    
    public func updateEventType(eventType: EventType) {
        self.eventType = eventType
    }
}
