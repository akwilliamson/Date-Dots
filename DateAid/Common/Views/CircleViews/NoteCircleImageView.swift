//
//  NoteTypeCircleImageView.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/3/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class NoteCircleImageView: CircleImageView {
    
    // MARK: Constants
    
    private enum Constant {
        static let borderWidth: CGFloat = 3
    }

    // MARK: Properties
    
    let noteType: NoteType
    var eventType: EventType? = nil
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(noteType: NoteType) {
        self.noteType = noteType
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
        if let eventType = eventType {
            layer.borderColor = eventType.color.cgColor
        } else {
            layer.borderColor = UIColor.compatibleLabel.cgColor
        }
        
        if isSelected {
            if let eventType = eventType {
                backgroundColor = eventType.color
                image = noteType.image.withTintColor(.white)
            } else {
                backgroundColor = UIColor.compatibleLabel
                image = noteType.image.withTintColor(.black)
            }
        } else {
            if let eventType = eventType {
                backgroundColor = .compatibleSystemBackground
                image = noteType.image.withTintColor(eventType.color)
            } else {
                backgroundColor = .compatibleSystemBackground
                image = noteType.image
            }
        }
    }
}
