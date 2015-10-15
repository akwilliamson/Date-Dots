//
//  TypeButton.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/8/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

class TypeButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 20
    }
}