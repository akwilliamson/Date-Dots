//
//  EventCell.swift
//  Date Dots
//
//  Created by Aaron Williamson on 6/13/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    // MARK: UI
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextDemiBold(20).font
        default:
            label.font = FontType.avenirNextDemiBold(25).font
        }
        label.textColor = UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 1.0)
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextMedium(18).font
        default:
            label.font = FontType.avenirNextMedium(25).font
        }
        label.textColor = UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 1.0)
        label.minimumScaleFactor = 0.5
        return label
    }()

    // MARK: Properties
    
    public var event: Event? {
        didSet {
            populate(event)
        }
    }
    
    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        constructViews()
        constrainViews()
    }

    // MARK: View Setup

    private func configureView() {
        selectionStyle = .none
    }
    
    private func constructViews() {
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(dateLabel)
    }
    
    private func constrainViews() {
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: Helper Methods

    private func populate(_ event: Event?) {
        guard let event = event else { return }

        iconImageView.image = event.eventType.selectedImage
        iconImageView.layer.cornerRadius = 12
        
        nameLabel.textColor = event.eventType.color
        nameLabel.text = event.fullName
        
        dateLabel.text = event.date.formatted("MMM dd")
    }
}
