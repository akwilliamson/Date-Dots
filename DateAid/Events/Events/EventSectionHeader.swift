//
//  EventSectionHeader.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/7/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventSectionHeaderDelegate: class {
    
    func didSelectSectionHeader(event: Event)
}

class EventSectionHeader: UIView {
    
    // MARK: UI
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
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
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextMedium(16).font
        default:
            label.font = FontType.avenirNextMedium(22).font
        }
        label.textColor = UIColor.systemGray
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let horizontalRule: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.compatibleSystemGray3
        return view
    }()
    
    // MARK: Properties
    
    /// The event to populate the section header with
    var event: Event?
    /// The delegate to handle user-driven events
    var delegate: EventSectionHeaderDelegate?
    
    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        constructViews()
        constrainViews()
    }

    // MARK: View Setup
    
    private func configureView() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectSectionHeader)))
    }
    
    private func constructViews() {
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(dateLabel)
        addSubview(horizontalRule)
    }
    
    convenience init(event: Event) {
        self.init(frame: .zero)
        self.event = event
        populate(event)
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
            nameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            horizontalRule.bottomAnchor.constraint(equalTo: bottomAnchor),
            horizontalRule.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            horizontalRule.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            horizontalRule.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: Interface
    
    @objc
    func didSelectSectionHeader() {
        guard let event = event else { return }
        delegate?.didSelectSectionHeader(event: event)
    }

    // MARK: Helper Methods

    private func populate(_ event: Event?) {
        guard let event = event else { return }

        iconImageView.backgroundColor = event.eventType.color
        iconImageView.image = event.eventType.image
        
        nameLabel.textColor = event.eventType.color
        nameLabel.text = event.fullName
        
        dateLabel.text = event.date.formatted("MMM dd")
    }
}
