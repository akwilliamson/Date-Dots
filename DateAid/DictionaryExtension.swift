//
//  DictionaryExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/23/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension Dictionary where Value : Equatable {
    
    func allKeysForValue(val : Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}