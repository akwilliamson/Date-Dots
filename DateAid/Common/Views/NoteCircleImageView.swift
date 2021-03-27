//
//  NoteTypeCircleImageView.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/3/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class NoteCircleImageView: CircleImageView {

    // MARK: Properties
    
    private var isSelected = false
    
    // MARK: Public Methods
    
    public func setImage(for noteType: NoteType) {
        image = noteType.image
    }
    
    public func setSelectedState(isSelected: Bool, color: UIColor? = nil) {
        self.isSelected = isSelected
        
        if isSelected {
            image = image?.withRenderingMode(.alwaysTemplate)
            layer.borderColor = color?.cgColor ?? UIColor.compatibleLabel.cgColor
            tintColor = color ?? UIColor.compatibleLabel
        } else {
            image = image?.withRenderingMode(.alwaysTemplate)
            layer.borderColor = UIColor.compatibleSystemGray3.cgColor
            tintColor = UIColor.compatibleSystemGray3
        }
    }
}
