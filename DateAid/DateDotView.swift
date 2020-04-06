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

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = dateType.color.cgColor
        view.layer.borderWidth = 4
        return view
    }()
    
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
        containerView.layer.cornerRadius = containerView.frame.width/2
    }

    // MARK: View Setup

    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
    }

    private func constructViews() {
        addSubview(containerView)
        containerView.addSubview(iconImageView)
    }

    private func constrainViews() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            iconImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            iconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])

        layoutIfNeeded()
    }

    // MARK: Public Methods
    
    public func updateImage(_ isSelected: Bool) {
        iconImageView.image = isSelected ? dateType.selectedImage : dateType.unselectedImage
    }
}
