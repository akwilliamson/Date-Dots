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
        let fontSize: CGFloat
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            fontSize = 14
        default:
            fontSize = 18
        }

        return address?.street == nil ? FontType.avenirNextDemiBold(fontSize).font : FontType.noteworthyBold(fontSize).font
    }
    
    var regionText: String {
        return address?.region ?? "City, State, Zip"
    }
    
    var regionColor: UIColor {
        return address?.region == nil ? .compatibleLabel : eventType.color
    }
    
    var regionFont: UIFont {
        let fontSize: CGFloat
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            fontSize = 14
        default:
            fontSize = 18
        }
        
        return address?.region == nil ? FontType.avenirNextDemiBold(fontSize).font : FontType.noteworthyBold(fontSize).font
    }
    
    // MARK: Public Methods
    
    public func updateAddress(address: Address?) {
        self.address = address
    }
    
    public func updateEventType(eventType: EventType) {
        self.eventType = eventType
    }
}
