//
//  ConstructableView.swift
//  Date Dots
//
//  Created by Aaron Williamson on 5/9/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import Foundation

protocol ConstructableView {
    
    func constructSubviewHierarchy()
    func constructLayout()
}

extension ConstructableView {
    
    public func construct() {
        constructSubviewHierarchy()
        constructLayout()
    }
}
