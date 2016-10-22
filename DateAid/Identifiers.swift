//
//  Identifiers.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/15/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation

protocol Stringable: RawRepresentable {
    var value: String { get }
}

extension Stringable {
    var value: String { return self.rawValue as? String ?? "Not Stringable" }
}

struct Id {

    enum Cell: String, Stringable {
        case dateCell = "DateCell"
    }

    enum Segue: String, Stringable {
        case dateDetails = "DateDetails"
        case addDate     = "AddDate"
    }
}
