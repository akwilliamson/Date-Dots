//
//  DateSetupView.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/4/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class DateSetupView: BaseView {
    
    // MARK: Content
    
    struct Content {
        let whoText: String
        let whatText: String
        let whenText: String
        let whereText: String
        let whyText: String
        let firstNamePlaceholderText: String
        let lastNamePlaceholderText: String
        let addressOnePlaceholderText: String
        let addressTwoPlaceholderText: String
        let whyDescriptionText: String
    }
    
    // MARK: UI
    
    private let containerStackView: UIStackView
    // Who
    private let whoLabel: UILabel
    private let whoStackView: UIStackView
    private let firstNameTextView: UITextView
    private let lastNameTextView: UITextView
    // What
    private let whatLabel: UILabel
    private let whatStackView: UIStackView
    private let birthdayDot: IconCircleImageView
    private let anniversaryDot: IconCircleImageView
    private let holidayDot: IconCircleImageView
    private let otherDot: IconCircleImageView
    // When
    private let whenLabel: UILabel
    private let whenDatePicker: UIDatePicker
    // Where
    private let whereLabel: UILabel
    private let whereStackView: UIStackView
    private let addressOneTextView: UITextView
    private let addressTwoTextView: UITextView
    // Why
    private let whyLabel: UILabel
    private let whyDescriptionLabel: UILabel
    
    // MARK: Properties
    
    var textViewDelegate: UITextViewDelegate?
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        containerStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.distribution = .fill
            return stackView
        }()
        
        whoLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
            return label
        }()
        
        whoStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 8
            return stackView
        }()
        
        firstNameTextView = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
            textView.layer.borderColor = UIColor.compatibleSystemGray3.cgColor
            textView.layer.borderWidth = 3
            return textView
        }()
        
        lastNameTextView = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
            textView.layer.borderColor = UIColor.compatibleSystemGray3.cgColor
            textView.layer.borderWidth = 3
            return textView
        }()
        
        whatLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
            return label
        }()
        
        whatStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 8
            stackView.distribution = .fillEqually
            return stackView
        }()
        
        birthdayDot = {
            let imageView = IconCircleImageView(dateType: .birthday)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        anniversaryDot = {
            let imageView = IconCircleImageView(dateType: .anniversary)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        holidayDot = {
            let imageView = IconCircleImageView(dateType: .holiday)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        otherDot = {
            let imageView = IconCircleImageView(dateType: .other)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        whenLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
            return label
        }()
        
        whenDatePicker = {
            let datePicker = UIDatePicker()
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            datePicker.datePickerMode = .date
            return datePicker
        }()
        
        whereLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
            return label
        }()
        
        whereStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 8
            return stackView
        }()
        
        addressOneTextView = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
            textView.layer.borderColor = UIColor.compatibleSystemGray3.cgColor
            textView.layer.borderWidth = 3
            return textView
        }()
        
        addressTwoTextView = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
            textView.layer.borderColor = UIColor.compatibleSystemGray3.cgColor
            textView.layer.borderWidth = 3
            return textView
        }()
        
        whyLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
            return label
        }()
        
        whyDescriptionLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
            return label
        }()
        
        super.init(frame: frame)
        
        firstNameTextView.delegate  = textViewDelegate
        lastNameTextView.delegate   = textViewDelegate
        addressOneTextView.delegate = textViewDelegate
        addressTwoTextView.delegate = textViewDelegate

        configureView()
    }
    
    private func configureView() {
        backgroundColor = .compatibleSystemBackground
    }
    
    override func constructSubviewHierarchy() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(whoLabel)
        containerStackView.setCustomSpacing(12, after: whoLabel)
        containerStackView.addArrangedSubview(whoStackView)
        containerStackView.setCustomSpacing(12, after: whoStackView)
        whoStackView.addArrangedSubview(firstNameTextView)
        whoStackView.addArrangedSubview(lastNameTextView)
        containerStackView.setCustomSpacing(12, after: lastNameTextView)
        containerStackView.addArrangedSubview(whatLabel)
        containerStackView.setCustomSpacing(12, after: whatLabel)
        containerStackView.addArrangedSubview(whatStackView)
        whatStackView.addArrangedSubview(birthdayDot)
        whatStackView.addArrangedSubview(anniversaryDot)
        whatStackView.addArrangedSubview(holidayDot)
        whatStackView.addArrangedSubview(otherDot)
        containerStackView.setCustomSpacing(12, after: whatStackView)
        containerStackView.addArrangedSubview(whenLabel)
        containerStackView.setCustomSpacing(12, after: whenLabel)
        containerStackView.addArrangedSubview(whenDatePicker)
        containerStackView.setCustomSpacing(12, after: whenDatePicker)
        containerStackView.addArrangedSubview(whereLabel)
        containerStackView.setCustomSpacing(12, after: whereLabel)
        containerStackView.addArrangedSubview(whereStackView)
        whereStackView.addArrangedSubview(addressOneTextView)
        whereStackView.addArrangedSubview(addressTwoTextView)
        containerStackView.setCustomSpacing(12, after: whereStackView)
        containerStackView.addArrangedSubview(whyLabel)
        containerStackView.setCustomSpacing(12, after: whyLabel)
        containerStackView.addArrangedSubview(whyDescriptionLabel)
    }
    
    override func constructLayout() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            whoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            whoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            whoLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            firstNameTextView.heightAnchor.constraint(equalToConstant: 40),
            firstNameTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            firstNameTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            lastNameTextView.heightAnchor.constraint(equalToConstant: 40),
            lastNameTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            lastNameTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            whatStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            whatStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        NSLayoutConstraint.activate([
            birthdayDot.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/6),
            birthdayDot.heightAnchor.constraint(equalTo: birthdayDot.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            whenDatePicker.heightAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            addressOneTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addressOneTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            addressOneTextView.heightAnchor.constraint(equalToConstant: 40),
            addressOneTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addressOneTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            addressTwoTextView.heightAnchor.constraint(equalToConstant: 40),
            addressTwoTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addressTwoTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            whyDescriptionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
}

// MARK: - Populatable

extension DateSetupView: Populatable {
    
    func populate(with content: Content) {
        whoLabel.text = content.whoText
        whatLabel.text = content.whatText
        whenLabel.text = content.whenText
        whereLabel.text = content.whereText
        whyLabel.text = content.whyText
        firstNameTextView.text = content.firstNamePlaceholderText
        lastNameTextView.text = content.lastNamePlaceholderText
        addressOneTextView.text = content.addressOnePlaceholderText
        addressTwoTextView.text = content.addressTwoPlaceholderText
        whyDescriptionLabel.text = content.whyDescriptionText
    }
}
