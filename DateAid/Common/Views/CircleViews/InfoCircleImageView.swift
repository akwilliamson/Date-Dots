//
//  InfoCircleImageView.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/18/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class InfoCircleImageView: CircleImageView {
    
    // MARK: Constant
    
    private enum Constant {
        static let borderWidth: CGFloat = 3
    }
    
    // MARK: Properties
    
    let infoType: InfoType
    var eventType: EventType = .birthday
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(infoType: InfoType) {
        self.infoType = infoType
        super.init()
        configureView()
    }
    
    // MARK: View Setup
    
    override func configureView() {
        super.configureView()
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFit
        layer.borderWidth = Constant.borderWidth
        layer.borderColor = eventType.color.cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            layer.shadowRadius = 5.0
            layer.shadowOpacity = 0.8
            layer.shadowOffset = CGSize(width: 2, height: 2)
        case .dark:
            layer.shadowRadius = 10.0
            layer.shadowOpacity = 1.0
            layer.shadowOffset = CGSize(width: 0, height: 0)
        default:
            break
        }
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
            image = infoType.image

        } else {
            backgroundColor = .compatibleSystemBackground
            image = infoType.image.withTintColor(eventType.color)
        }
    }
}
