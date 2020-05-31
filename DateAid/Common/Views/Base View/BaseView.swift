//
//  BaseView.swift
//  Date Dots
//
//  Created by Aaron Williamson on 5/9/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class BaseView: UIView, ConstructableView {
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    
    // MARK: - ConstructableView
    
    func constructSubviewHierarchy() {
        // No-op, implement in subclass.
    }
    
    func constructLayout() {
        // No-op, implement in subclass.
    }
}
