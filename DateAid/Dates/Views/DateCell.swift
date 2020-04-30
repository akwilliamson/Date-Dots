//
//  DateCell.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/13/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {

    // MARK: UI

    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 75)
        label.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.15)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 35)
        label.textColor = UIColor(red: 101/255, green: 101/255, blue: 101/255, alpha: 1.0)
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Medium", size: 25)
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

    // MARK: Helper Methods

    private func populate(_ date: Date?) {
        guard let date = date else { return }

        firstNameLabel.textColor = date.color
        
        if let lastName  = date.lastName  { lastNameLabel.text = lastName }
        if let firstName = date.firstName { firstNameLabel.text = firstName }
        if let date      = date.date      { dateLabel.text = date.formatted("MMM dd") }
    }
}
