//
//  EventDetailsView.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/13/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventDetailsViewDelegate: class {
    
    func didSelectInfoType(_ infoType: InfoType)
}

class EventDetailsView: BaseView {
    
    // MARK: Constants
    
    private enum Constant {
        enum String {
            static let turns = "turns"
            static let year = "year"
            static let `in` = "in"
            static let on = "on"
            static let addAddress = "Add\nAddress"
            static let addReminder = "Add\nReminder"
        }
    }
    
    // MARK: UI
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    // Details
    
    private let detailsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // Details - Days
    
    private let daysStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let inLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = Constant.String.in
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextMedium(16).font
        default:
            label.font = FontType.avenirNextMedium(20).font
        }
        return label
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextBold(18).font
        default:
            label.font = FontType.avenirNextBold(22).font
        }
        return label
    }()
    
    // Details - Age
    
    private let ageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let isLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constant.String.turns
        label.textAlignment = .center
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextMedium(16).font
        default:
            label.font = FontType.avenirNextMedium(20).font
        }
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextMedium(30).font
        default:
            label.font = FontType.avenirNextBold(36).font
        }
        return label
    }()
    
    // Details - Date
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let onLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constant.String.on
        label.textAlignment = .center
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextMedium(16).font
        default:
            label.font = FontType.avenirNextMedium(20).font
        }
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextBold(18).font
        default:
            label.font = FontType.avenirNextBold(22).font
        }
        return label
    }()
    
    // Address
    
    private let addressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "envelope")
        return imageView
    }()
    
    private let addressLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let addressLabelOne: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.textColor = .compatibleSystemGray
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.noteworthyBold(20).font
        default:
            label.font = FontType.noteworthyBold(26).font
        }
        return label
    }()
    
    private let addressLabelTwo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        label.textColor = .compatibleSystemGray
        label.isHidden = true
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.noteworthyBold(20).font
        default:
            label.font = FontType.noteworthyBold(26).font
        }
        return label
    }()
    
    // Reminder
    
    private let reminderContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.compatibleSystemBackground.cgColor
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
        return view
    }()
    
    private let reminderIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let reminderEventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let reminderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .compatibleSystemGray
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.noteworthyBold(20).font
        default:
            label.font = FontType.noteworthyBold(26).font
        }
        return label
    }()
    
    // Info Dots
    
    private let infoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var addressInfoDotView: InfoCircleImageView = {
        let eventType = event?.eventType ?? .birthday
        let dotView = InfoCircleImageView(infoType: .address, eventType: eventType)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()
    
    private lazy var reminderInfoDotView: InfoCircleImageView = {
        let eventType = event?.eventType ?? .birthday
        let dotView = InfoCircleImageView(infoType: .reminder, eventType: eventType)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reminderDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()
    
    // MARK: Properties
    
    weak var delegate: EventDetailsViewDelegate?
    
    private var event: Event?
    
    // MARK: View Setup
    
    override func configureView() {
        super.configureView()
        backgroundColor = .compatibleSystemBackground
    }
    
    override func constructSubviewHierarchy() {
        super.constructSubviewHierarchy()
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(detailsContainerView)
            detailsContainerView.addSubview(detailsStackView)
                detailsStackView.addArrangedSubview(daysStackView)
                    daysStackView.addArrangedSubview(inLabel)
                    daysStackView.addArrangedSubview(daysLabel)
                detailsStackView.addArrangedSubview(ageStackView)
                    ageStackView.addArrangedSubview(isLabel)
                    ageStackView.addArrangedSubview(ageLabel)
                detailsStackView.addArrangedSubview(dateStackView)
                    dateStackView.addArrangedSubview(onLabel)
                    dateStackView.addArrangedSubview(dateLabel)
        containerStackView.setCustomSpacing(36, after: detailsContainerView)
        containerStackView.addArrangedSubview(addressImageView)
            addressImageView.addSubview(addressLabelStackView)
                addressLabelStackView.addArrangedSubview(addressLabelOne)
                addressLabelStackView.addArrangedSubview(addressLabelTwo)
        containerStackView.addArrangedSubview(reminderContainerView)
            reminderContainerView.addSubview(reminderIconImageView)
            reminderContainerView.addSubview(reminderLabel)
            reminderContainerView.addSubview(reminderEventImageView)
        containerStackView.addArrangedSubview(infoContainerView)
            infoContainerView.addSubview(infoButtonStackView)
                infoButtonStackView.addArrangedSubview(addressInfoDotView)
                infoButtonStackView.addArrangedSubview(reminderInfoDotView)
    }
    
    override func constructLayout() {
        super.constructLayout()
        NSLayoutConstraint.activate([
            detailsContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 36),
            detailsContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            detailsContainerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/9)
        ])
        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: detailsContainerView.topAnchor),
            detailsStackView.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor, constant: 8),
            detailsStackView.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor, constant: -8)
        ])
        NSLayoutConstraint.activate([
            addressImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            addressImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            addressImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/6)
        ])
        NSLayoutConstraint.activate([
            addressLabelStackView.centerXAnchor.constraint(equalTo: addressImageView.centerXAnchor),
            addressLabelStackView.centerYAnchor.constraint(equalTo: addressImageView.centerYAnchor, constant: 8)
        ])
        NSLayoutConstraint.activate([
            reminderContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            reminderContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            reminderContainerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/6)
        ])
        NSLayoutConstraint.activate([
            reminderIconImageView.centerYAnchor.constraint(equalTo: reminderContainerView.centerYAnchor),
            reminderIconImageView.leadingAnchor.constraint(equalTo: reminderContainerView.leadingAnchor),
            reminderIconImageView.widthAnchor.constraint(equalToConstant: 75),
            reminderIconImageView.heightAnchor.constraint(equalToConstant: 75)
        ])
        NSLayoutConstraint.activate([
            reminderLabel.centerYAnchor.constraint(equalTo: reminderContainerView.centerYAnchor),
            reminderLabel.centerXAnchor.constraint(equalTo: reminderContainerView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            reminderEventImageView.centerYAnchor.constraint(equalTo: reminderContainerView.centerYAnchor),
            reminderEventImageView.trailingAnchor.constraint(equalTo: reminderContainerView.trailingAnchor),
            reminderEventImageView.widthAnchor.constraint(equalToConstant: 75),
            reminderEventImageView.heightAnchor.constraint(equalToConstant: 75)
        ])
        NSLayoutConstraint.activate([
            infoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            infoContainerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/12)
        ])
        NSLayoutConstraint.activate([
            infoButtonStackView.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor),
            infoButtonStackView.centerYAnchor.constraint(equalTo: infoContainerView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            addressInfoDotView.heightAnchor.constraint(equalTo: infoContainerView.heightAnchor),
            addressInfoDotView.widthAnchor.constraint(equalTo: addressInfoDotView.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            reminderInfoDotView.heightAnchor.constraint(equalTo: infoContainerView.heightAnchor),
            reminderInfoDotView.widthAnchor.constraint(equalTo: reminderInfoDotView.heightAnchor)
        ])
    }
    
    // MARK: Interface
    
    func setInitialInfoType(infoType: InfoType) {
        switch infoType {
        case .address:
            addressInfoDotView.setSelectedState(isSelected: true)
            reminderInfoDotView.setSelectedState(isSelected: false)
            reminderContainerView.isHidden = true
            addressImageView.isHidden = false
        case .reminder:
            reminderInfoDotView.setSelectedState(isSelected: true)
            addressInfoDotView.setSelectedState(isSelected: false)
            addressImageView.isHidden = true
            reminderContainerView.isHidden = false
        }
    }
    
    func selectDotFor(infoType: InfoType) {
        switch infoType {
        case .address:
            guard addressImageView.isHidden else { return }
            
            addressInfoDotView.setSelectedState(isSelected: true)
            reminderInfoDotView.setSelectedState(isSelected: false)
            
            UIView.animate(withDuration: 0.2) {
                self.reminderContainerView.alpha = 0
            } completion: { _ in
                self.reminderContainerView.isHidden = true
                self.addressImageView.isHidden = false
                UIView.animate(withDuration: 0.2) {
                    self.addressImageView.alpha = 1
                }
            }
        case .reminder:
            guard reminderContainerView.isHidden else { return }
            
            reminderInfoDotView.setSelectedState(isSelected: true)
            addressInfoDotView.setSelectedState(isSelected: false)
            
            UIView.animate(withDuration: 0.2) {
                self.addressImageView.alpha = 0
            } completion: { _ in
                self.addressImageView.isHidden = true
                self.reminderContainerView.isHidden = false
                UIView.animate(withDuration: 0.2) {
                    self.reminderContainerView.alpha = 1
                }
            }
        }
    }
    
    // MARK: Actions
    
    @objc
    func addressDotPressed() {
        delegate?.didSelectInfoType(.address)
    }
    
    @objc
    func reminderDotPressed() {
        delegate?.didSelectInfoType(.reminder)
    }
}

// MARK: - Populatable

extension EventDetailsView: Populatable {
    
    struct Content {
        let event: Event
        let daysBefore: EventReminderDaysBefore?
        let timeOfDay: Date?
    }
    
    func populate(with content: Content) {
        self.event = content.event
        
        // Event Details

        detailsContainerView.backgroundColor = content.event.eventType.color
        ageLabel.text = content.event.numOfYears
        daysLabel.text = content.event.daysAway
        dateLabel.text = content.event.dayOfYear
        
        switch content.event.eventType {
        case .birthday:
            isLabel.text = Constant.String.turns
        case .anniversary:
            isLabel.text = Constant.String.year
        default:
            ageStackView.isHidden = true
        }
        
        // Address Details
        
        let address = content.event.address
        
        if address?.street == nil && address?.region == nil {
            addressLabelTwo.isHidden = true
            
            addressLabelOne.isHidden = false
            addressLabelOne.text = Constant.String.addAddress
        } else {
            if let street = address?.street {
                addressLabelOne.text = street
                addressLabelOne.isHidden = false
            } else {
                addressLabelOne.isHidden = true
            }
            
            if let region = address?.region {
                addressLabelTwo.text = region
                addressLabelTwo.isHidden = false
            } else {
                addressLabelTwo.isHidden = true
            }
        }
        
        // Reminder Details
        
        if #available(iOS 13.0, *) {
            reminderEventImageView.image = content.event.eventType.image.withTintColor(.black)
        } else {
            tintColor = .black
        }
        
        if let daysBefore = content.daysBefore, let timeOfDay = content.timeOfDay {
            reminderIconImageView.image = UIImage(named: "reminder-set")
            let daysBeforeText = daysBefore.pickerText
            let timeOfDayText = timeOfDay.formatted("h:mm a")
            reminderLabel.text = "\(daysBeforeText)\n\(timeOfDayText)"
        } else {
            reminderIconImageView.image = UIImage(named: "reminder-add")
            reminderLabel.text = Constant.String.addReminder
        }
    }
}
