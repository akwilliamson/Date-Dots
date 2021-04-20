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
    var eventType: EventType
    
    private let scaledSize: CGSize = .zero
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(infoType: InfoType, eventType: EventType) {
        self.infoType = infoType
        self.eventType = eventType
        super.init()
        configureView()
    }
    
    // MARK: View Setup
    
    override func configureView() {
        super.configureView()
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFit
        layer.borderColor = eventType.color.cgColor
        
        if scaledSize != .zero {
            downsizeImage(to: scaledSize)
        }
    }
    
    // MARK: Interface
    
    func setSelectedState(isSelected: Bool) {
        updateImage(isSelected: isSelected)
    }
    
    // MARK: Private Methods
    
    private func updateImage(isSelected: Bool) {
        if isSelected {
            backgroundColor = eventType.color
            if #available(iOS 13.0, *) {
                image = infoType.image
            } else {
                tintColor = .white
            }

        } else {
            backgroundColor = .compatibleSystemBackground
            if #available(iOS 13.0, *) {
                image = infoType.image.withTintColor(eventType.color)
            } else {
                tintColor = eventType.color
            }
        }
    }
}
