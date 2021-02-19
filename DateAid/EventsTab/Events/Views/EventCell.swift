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

    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextDemiBold(55).font
        default:
            label.font = FontType.avenirNextDemiBold(75).font
        }
        label.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.15)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextDemiBold(25).font
        default:
            label.font = FontType.avenirNextDemiBold(35).font
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
    
    public var date: Date? {
        didSet {
            populate(date)
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
        addSubview(lastNameLabel)
        addSubview(firstNameLabel)
        addSubview(dateLabel)
    }
    
    private func constrainViews() {
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            NSLayoutConstraint.activate([
                lastNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                lastNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
                lastNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
                lastNameLabel.heightAnchor.constraint(equalToConstant: 55),
                lastNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
            NSLayoutConstraint.activate([
                firstNameLabel.topAnchor.constraint(equalTo: topAnchor),
                firstNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                firstNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            NSLayoutConstraint.activate([
                dateLabel.topAnchor.constraint(equalTo: topAnchor),
                dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        default:
            NSLayoutConstraint.activate([
                lastNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
                lastNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
                lastNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
                lastNameLabel.heightAnchor.constraint(equalToConstant: 80),
                lastNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
            ])
            NSLayoutConstraint.activate([
                firstNameLabel.topAnchor.constraint(equalTo: topAnchor),
                firstNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                firstNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            NSLayoutConstraint.activate([
                dateLabel.topAnchor.constraint(equalTo: topAnchor),
                dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }

    // MARK: Helper Methods

    private func populate(_ event: Date?) {
        guard let event = event else { return }

        firstNameLabel.textColor = event.eventType.color
        
        if let lastName  = event.lastName  { lastNameLabel.text = lastName }
        if let firstName = event.firstName { firstNameLabel.text = firstName }
        if let date      = event.date      { dateLabel.text = date.formatted("MMM dd") }
    }
}
