//
//  InfoCircleImageView.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/18/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class InfoCircleImageView: CircleImageView {
    
    // MARK: Properties
    
    let infoType: InfoType
    
    var isSelected = false {
        didSet {
            updateImage(isSelected: isSelected)
        }
    }
    
    private let scaledSize: CGSize
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(infoType: InfoType, scaledSize: CGSize = .zero) {
        self.infoType = infoType
        self.scaledSize = scaledSize
        super.init()
        configureView()
    }
    
    // MARK: View Setup
    
    override func configureView() {
        super.configureView()
        isUserInteractionEnabled = true
        contentMode = .center
        layer.borderWidth = 5
        
        if scaledSize != .zero {
            downsizeImage(to: scaledSize)
        }
    }
    
    // MARK: Interface
    
    func setSelectedState(isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    // MARK: Private Methods
    
    private func updateImage(isSelected: Bool) {
        if isSelected {
            backgroundColor = .white
            layer.borderColor = UIColor.white.cgColor
            image = infoType.selectedImage
        } else {
            backgroundColor = .compatibleSystemBackground
            layer.borderColor = UIColor.compatibleSystemGray.cgColor
            image = infoType.unselectedImage
        }
        
        if scaledSize != .zero {
            downsizeImage(to: scaledSize)
        }
    }
}
