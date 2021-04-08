//
//  EventListCell.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/11/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class EventListCell: UITableViewCell {

    // MARK: UI
    
    private let eventTypeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextMedium(20).font
        default:
            label.font = FontType.avenirNextMedium(25).font
        }
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextMedium(15).font
        default:
            label.font = FontType.avenirNextMedium(20).font
        }
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
        addSubview(eventTypeIcon)
        addSubview(nameLabel)
        addSubview(dateLabel)
    }
    
    private func constrainViews() {
        NSLayoutConstraint.activate([
            eventTypeIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            eventTypeIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            eventTypeIcon.widthAnchor.constraint(equalToConstant: 24),
            eventTypeIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: eventTypeIcon.trailingAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
    }

    // MARK: Helper Methods

    private func populate(_ event: Event?) {
        guard let event = event else { return }

        eventTypeIcon.image = event.eventType.selectedImage
        eventTypeIcon.layer.cornerRadius = 12
        
        nameLabel.text = event.fullName
        nameLabel.textColor = event.eventType.color
        
        dateLabel.text = event.date.formatted("MMM dd")
        dateLabel.textColor = UIColor.compatibleLabel
    }
}
