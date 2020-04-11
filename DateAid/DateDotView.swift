//
//  DateDotView.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/30/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class DateDotView: UIView {
    
    // MARK: UI
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = dateType.unselectedImage
        return imageView
    }()
    
    // MARK: Properties
    
    public let dateType: DateType
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(dateType: DateType) {
        self.dateType = dateType
        super.init(frame: .zero)
        configureView()
        constructViews()
        constrainViews()
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.width/2
    }

    // MARK: View Setup

    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.borderColor = dateType.color.cgColor
        layer.borderWidth = 4
    }

    private func constructViews() {
        addSubview(iconImageView)
    }

    private func constrainViews() {
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])

        layoutIfNeeded()
    }

    // MARK: Public Methods
    
    public func updateImage(isSelected: Bool) {
        if isSelected {
            backgroundColor = dateType.color
            iconImageView.image = dateType.selectedImage
        } else {
            backgroundColor = .clear
            iconImageView.image = dateType.unselectedImage
        }
    }
}
