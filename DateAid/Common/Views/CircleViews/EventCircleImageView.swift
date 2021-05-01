//
//  EventCircleImageView.swift
//  Date Dots
//
//  Created by Aaron Williamson on 3/30/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class EventCircleImageView: CircleImageView {
    
    // MARK: Constants
    
    private enum Constant {
        static let borderWidth: CGFloat = 5
    }

    // MARK: Properties
    
    var eventType: EventType = .birthday
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(eventType: EventType) {
        self.eventType = eventType
        super.init()
        configureView()
    }

    // MARK: View Setup
    
    override func configureView() {
        super.configureView()
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFit
        layer.borderWidth = Constant.borderWidth
    }

    // MARK: Interface
    
    func setSelectedState(isSelected: Bool) {
        updateImage(isSelected: isSelected)
    }
    
    // MARK: Private Methods
    
    private func updateImage(isSelected: Bool) {
        layer.borderColor = eventType.color.cgColor

        if isSelected {
            backgroundColor = eventType.color
            if #available(iOS 13.0, *) {
                image = eventType.image
            } else {
                tintColor = .white
            }
        } else {
            backgroundColor = .compatibleSystemBackground
            if #available(iOS 13.0, *) {
                image = eventType.image.withTintColor(eventType.color)
            } else {
                tintColor = eventType.color
            }
        }
    }
}
