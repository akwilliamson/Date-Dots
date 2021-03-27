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
    
    public let eventType: EventType
    public var scaledSize: CGSize
    
    public var isSelected = false {
        didSet {
            updateImage(isSelected: isSelected)
        }
    }
    
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
        image = eventType.unselectedImage
        layer.borderColor = eventType.color.cgColor
        
        if scaledSize != .zero {
            downsizeImage(to: scaledSize)
        }
    }

    // MARK: Public Methods
    
    public func setSelectedState(isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    private func updateImage(isSelected: Bool) {
        if isSelected {
            backgroundColor = eventType.color
            image = eventType.selectedImage
        } else {
            backgroundColor = .clear
            image = eventType.unselectedImage
        }
        
        if scaledSize != .zero {
            downsizeImage(to: scaledSize)
        }
    }
}
