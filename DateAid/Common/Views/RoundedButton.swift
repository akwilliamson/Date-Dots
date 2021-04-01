//
//  RoundedButton.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/31/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height/2
    }
}
