//
//  EventCircleImageView.swift
//  Date Dots
//
//  Created by Aaron Williamson on 3/30/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class EventCircleImageView: CircleImageView {

    // MARK: Properties
    
    let eventType: EventType
    
    var isSelected = false {
        didSet {
            updateImage(isSelected: isSelected)
        }
    }
    
    private var scaledSize: CGSize
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(eventType: EventType, scaledSize: CGSize = .zero) {
        self.eventType = eventType
        self.scaledSize = scaledSize
        super.init()
        configureView()
    }

    // MARK: View Setup
    
    override func configureView() {
        super.configureView()
        isUserInteractionEnabled = true
        image = eventType.unselectedImage
        contentMode = .center
        layer.borderColor = eventType.color.cgColor
        
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
            backgroundColor = eventType.color
            image = eventType.selectedImage
        } else {
            backgroundColor = .compatibleSystemBackground
            image = eventType.unselectedImage
        }
        
        if scaledSize != .zero {
            downsizeImage(to: scaledSize)
        }
    }
}
