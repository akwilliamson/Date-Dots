//
//  Identifiers.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/15/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation

enum SegueId: String {

    case dateDetails = "DateDetails"
    case addDate     = "AddDate"
    
    var value: String {
        return self.rawValue
    }
}

enum CellId: String {
    
    case dateCell = "DateCell"
    
    var value: String {
        return self.rawValue
    }
}
