//
//  PaddedTextField.swift
//  Date Dots
//
//  Created by Aaron Williamson on 5/17/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class PaddedTextField: UITextField {

    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: View Setup

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect.init(x: bounds.origin.x + 8, y: bounds.origin.y, width: bounds.width - 8, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds:bounds)
    }
}
