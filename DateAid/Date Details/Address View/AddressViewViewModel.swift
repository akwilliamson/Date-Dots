//
//  AddressViewViewModel.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/29/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import Foundation

struct AddressViewViewModel {
    
    let address: Address?
    let dateType: DateType
    
    var addressText: String {
        guard
            let street = address?.street,
            let region = address?.region
        else {
            return "No Address"
        }

        return "\(street)\n\(region)"
    }
}
