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
    
    private let eventCircleImageView: EventCircleImageView = {
        let imageView = EventCircleImageView(eventType: .birthday)
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
        addSubview(eventCircleImageView)
        addSubview(nameLabel)
        addSubview(dateLabel)
    }
    
    private func constrainViews() {
        NSLayoutConstraint.activate([
            eventCircleImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            eventCircleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            eventCircleImageView.widthAnchor.constraint(equalToConstant: 24),
            eventCircleImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: eventCircleImageView.trailingAnchor, constant: 8),
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

        eventCircleImageView.eventType = event.eventType
        eventCircleImageView.setSelectedState(isSelected: true)
        
        nameLabel.text = event.fullName
        nameLabel.textColor = event.eventType.color
        
        dateLabel.text = event.date.formatted("MMM dd")
        dateLabel.textColor = UIColor.compatibleLabel
    }
}
