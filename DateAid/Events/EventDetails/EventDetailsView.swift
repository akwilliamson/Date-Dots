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
            static let noAddress = "No Address Saved"
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
        label.numberOfLines = 1
        label.textColor = .compatibleSystemGray
        // Address #1 font is initially set to no-address styling
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextDemiBold(18).font
        default:
            label.font = FontType.avenirNextDemiBold(22).font
        }
        return label
    }()
    
    private let addressLabelTwo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textColor = .compatibleSystemGray
        label.isHidden = true
        // Address #2 font will always be added address styling when shown
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.noteworthyBold(18).font
        default:
            label.font = FontType.noteworthyBold(22).font
        }
        return label
    }()
    
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
        let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
        let dotView = InfoCircleImageView(infoType: .address, scaledSize: size)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()
    
    private lazy var reminderInfoDotView: InfoCircleImageView = {
        let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
        let dotView = InfoCircleImageView(infoType: .reminder, scaledSize: size)
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
            addressLabelStackView.centerYAnchor.constraint(equalTo: addressImageView.centerYAnchor, constant: 12)
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
    
    func selectDotFor(infoType: InfoType) {
        switch infoType {
        case .address:
            addressInfoDotView.setSelectedState(isSelected: true)
            reminderInfoDotView.setSelectedState(isSelected: false)
        case .reminder:
            reminderInfoDotView.setSelectedState(isSelected: true)
            addressInfoDotView.setSelectedState(isSelected: false)
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
    }
    
    func populate(with content: Content) {
        self.event = content.event
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
        
        let address = content.event.address
        
        if address?.street == nil && address?.region == nil {
            addressLabelTwo.isHidden = true
            
            addressLabelOne.isHidden = false
            addressLabelOne.text = Constant.String.noAddress
            switch UIDevice.type {
            case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                addressLabelOne.font = FontType.avenirNextDemiBold(18).font
            default:
                addressLabelOne.font = FontType.avenirNextDemiBold(22).font
            }
        } else {
            if let street = address?.street {
                addressLabelOne.text = street
                addressLabelOne.isHidden = false
                switch UIDevice.type {
                case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                    addressLabelOne.font = FontType.noteworthyBold(18).font
                default:
                    addressLabelOne.font = FontType.noteworthyBold(22).font
                }
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
    }
}
