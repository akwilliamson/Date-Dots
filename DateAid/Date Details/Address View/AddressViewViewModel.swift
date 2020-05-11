//
//  AddressViewViewModel.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/29/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class AddressViewViewModel {
    
    // MARK: Initialization
    
    init(address: Address?, dateType: DateType) {
        self.address = address
        self.dateType = dateType
    }
    
    // MARK: Private Properties
    
    private let address: Address?
    private let dateType: DateType
    
    // MARK: Public Properties
    
    var isEditing = false
    
    var addressText: String {
        return address?.street ?? "Address"
    }
    
    var addressColor: UIColor {
        return address?.street == nil ? .compatibleLabel : dateType.color
    }
    
    var addressFont: UIFont {
        return address?.street == nil ? UIFont(name: "AvenirNext-DemiBold", size: 18)! : UIFont(name: "Noteworthy-Bold", size: 20)!
    }
    
    var regionText: String {
        return address?.region ?? "City, State, Zip"
    }
    
    var regionColor: UIColor {
        return address?.region == nil ? .compatibleLabel : dateType.color
    }
    
    var regionFont: UIFont {
        return address?.region == nil ? UIFont(name: "AvenirNext-DemiBold", size: 18)! : UIFont(name: "Noteworthy-Bold", size: 20)!
    }
    
    var editButtonTitle: String  {
        switch isEditing {
        case true:  return "Save"
        case false: return "Edit"
        }
    }

    func didTapEditButton() {
        isEditing = !isEditing
    }
    
    func setAddress(streetText: String?, regionText: String?) {
        address?.street = streetText
        address?.region = regionText
    }
}
