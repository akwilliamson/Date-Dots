//
//  Populatable.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/9/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import Foundation

protocol Populatable {
    associatedtype Content
    
    func populate(with content: Content)
}
