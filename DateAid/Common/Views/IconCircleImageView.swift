//
//  DateDotView.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/30/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class IconCircleImageView: CircleImageView {

    // MARK: Properties
    
    public let dateType: DateType
    
    public var isSelected = false {
        didSet {
            updateImage(isSelected: isSelected)
        }
    }
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(dateType: DateType) {
        self.dateType = dateType
        super.init()
        configureView()
    }

    // MARK: View Setup
    
    override func configureView() {
        super.configureView()
        image = dateType.unselectedImage
        layer.borderColor = dateType.color.cgColor
    }

    // MARK: Public Methods
    
    public func setSelectedState(isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    private func updateImage(isSelected: Bool) {
        if isSelected {
            backgroundColor = dateType.color
            image = dateType.selectedImage
        } else {
            backgroundColor = .clear
            image = dateType.unselectedImage
        }
    }
}
