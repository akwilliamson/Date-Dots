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
    func didSelectNoteType(_ noteType: NoteType)
}

class EventDetailsView: BaseView {
    
    // MARK: Constants
    
    private enum Constant {
        enum String {
            static let turns = "turns"
            static let year = "year"
            static let `in` = "in"
            static let on = "on"
            static let addAddress = "Add Address"
            static let addReminder = "Add\nReminder"
            static let addNote = "Add"
            static let noDescription = "No Description"
        }
        enum Image {
            static let reminderSet = UIImage(named: "reminder-set")
            static let addReminder = UIImage(named: "reminder-add")
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
    
    // Info - Address
    
    private let addressContainerView: UIImageView = {
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
    
    // Info - Reminder
    
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
    
    // Info - Dots
    
    private let infoButtonContainerView: UIView = {
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
        let dotView = InfoCircleImageView(infoType: .address)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()
    
    private lazy var reminderInfoDotView: InfoCircleImageView = {
        let dotView = InfoCircleImageView(infoType: .reminder)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reminderDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()
    
    // Notes
    
    private let notesContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let noteTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextBold(20).font
        default:
            label.font = FontType.avenirNextBold(24).font
        }
        return label
    }()
    
    private let noteDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.textAlignment = .left
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextMedium(18).font
        default:
            label.font = FontType.avenirNextMedium(22).font
        }
        return label
    }()
    
    // Note - Dots
    
    private let noteButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let noteButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var giftsNoteDotView: NoteCircleImageView = {
        let dotView = NoteCircleImageView(noteType: .gifts)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(giftsDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()
    
    private lazy var plansNoteDotView: NoteCircleImageView = {
        let dotView = NoteCircleImageView(noteType: .plans)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(plansDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()
    
    private lazy var otherNoteDotView: NoteCircleImageView = {
        let dotView = NoteCircleImageView(noteType: .other)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(otherDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()
    
    // MARK: Properties
    
    weak var delegate: EventDetailsViewDelegate?
    
    private var event: Event?
    
    private var selectedInfoType: InfoType = .address
    private var selectedNoteType: NoteType = .gifts
    
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
        containerStackView.addArrangedSubview(addressContainerView)
            addressContainerView.addSubview(addressLabelStackView)
                addressLabelStackView.addArrangedSubview(addressLabelOne)
                addressLabelStackView.addArrangedSubview(addressLabelTwo)
        containerStackView.addArrangedSubview(reminderContainerView)
            reminderContainerView.addSubview(reminderIconImageView)
            reminderContainerView.addSubview(reminderLabel)
            reminderContainerView.addSubview(reminderEventImageView)
        containerStackView.addArrangedSubview(infoButtonContainerView)
            infoButtonContainerView.addSubview(infoButtonStackView)
                infoButtonStackView.addArrangedSubview(addressInfoDotView)
                infoButtonStackView.addArrangedSubview(reminderInfoDotView)
        containerStackView.setCustomSpacing(36, after: infoButtonContainerView)
        containerStackView.addArrangedSubview(notesContainerView)
            notesContainerView.addSubview(noteTitleLabel)
            notesContainerView.addSubview(noteDescriptionLabel)
        containerStackView.addArrangedSubview(noteButtonContainerView)
            noteButtonContainerView.addSubview(noteButtonStackView)
                noteButtonStackView.addArrangedSubview(giftsNoteDotView)
                noteButtonStackView.addArrangedSubview(plansNoteDotView)
                noteButtonStackView.addArrangedSubview(otherNoteDotView)
    }
    
    override func constructLayout() {
        super.constructLayout()
        
        // Details
        
        NSLayoutConstraint.activate([
            detailsContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 36),
            detailsContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            detailsContainerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/9)
        ])
        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: detailsContainerView.topAnchor),
            detailsStackView.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor, constant: 8),
            detailsStackView.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor, constant: -8),
            detailsStackView.bottomAnchor.constraint(equalTo: detailsContainerView.bottomAnchor)
        ])
        
        // Info
        
        NSLayoutConstraint.activate([
            addressContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            addressContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            addressContainerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/6)
        ])
        NSLayoutConstraint.activate([
            addressLabelStackView.centerXAnchor.constraint(equalTo: addressContainerView.centerXAnchor),
            addressLabelStackView.centerYAnchor.constraint(equalTo: addressContainerView.centerYAnchor, constant: 8)
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
            reminderEventImageView.trailingAnchor.constraint(equalTo: reminderContainerView.trailingAnchor, constant: -8),
            reminderEventImageView.widthAnchor.constraint(equalToConstant: 75),
            reminderEventImageView.heightAnchor.constraint(equalToConstant: 75)
        ])
        NSLayoutConstraint.activate([
            infoButtonContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoButtonContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            infoButtonContainerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/12)
        ])
        NSLayoutConstraint.activate([
            infoButtonStackView.centerXAnchor.constraint(equalTo: infoButtonContainerView.centerXAnchor),
            infoButtonStackView.centerYAnchor.constraint(equalTo: infoButtonContainerView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            addressInfoDotView.heightAnchor.constraint(equalTo: infoButtonContainerView.heightAnchor),
            addressInfoDotView.widthAnchor.constraint(equalTo: addressInfoDotView.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            reminderInfoDotView.heightAnchor.constraint(equalTo: infoButtonContainerView.heightAnchor),
            reminderInfoDotView.widthAnchor.constraint(equalTo: reminderInfoDotView.heightAnchor)
        ])
        
        // Notes
        
        NSLayoutConstraint.activate([
            notesContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            notesContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            notesContainerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/5.5)
        ])
        NSLayoutConstraint.activate([
            noteTitleLabel.topAnchor.constraint(equalTo: notesContainerView.topAnchor, constant: 8),
            noteTitleLabel.leadingAnchor.constraint(equalTo: notesContainerView.leadingAnchor, constant: 8),
            noteTitleLabel.trailingAnchor.constraint(equalTo: notesContainerView.trailingAnchor, constant: -8)
        ])
        NSLayoutConstraint.activate([
            noteDescriptionLabel.topAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor, constant: 8),
            noteDescriptionLabel.bottomAnchor.constraint(equalTo: notesContainerView.bottomAnchor, constant: -8),
            noteDescriptionLabel.leadingAnchor.constraint(equalTo: notesContainerView.leadingAnchor, constant: 8),
            noteDescriptionLabel.trailingAnchor.constraint(equalTo: notesContainerView.trailingAnchor, constant: -8)
        ])
        NSLayoutConstraint.activate([
            noteButtonContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            noteButtonContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            noteButtonContainerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/12)
        ])
        NSLayoutConstraint.activate([
            noteButtonStackView.centerXAnchor.constraint(equalTo: noteButtonContainerView.centerXAnchor),
            noteButtonStackView.centerYAnchor.constraint(equalTo: noteButtonContainerView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            giftsNoteDotView.heightAnchor.constraint(equalTo: noteButtonContainerView.heightAnchor),
            giftsNoteDotView.widthAnchor.constraint(equalTo: giftsNoteDotView.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            plansNoteDotView.heightAnchor.constraint(equalTo: noteButtonContainerView.heightAnchor),
            plansNoteDotView.widthAnchor.constraint(equalTo: plansNoteDotView.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            otherNoteDotView.heightAnchor.constraint(equalTo: noteButtonContainerView.heightAnchor),
            otherNoteDotView.widthAnchor.constraint(equalTo: otherNoteDotView.heightAnchor)
        ])
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
    
    @objc
    func giftsDotPressed() {
        delegate?.didSelectNoteType(.gifts)
    }
    
    @objc
    func plansDotPressed() {
        delegate?.didSelectNoteType(.plans)
    }
    
    @objc
    func otherDotPressed() {
        delegate?.didSelectNoteType(.other)
    }
    
    // MARK: Interface
    
    func select(infoType: InfoType) {
        switch infoType {
        case .address:
            guard selectedInfoType != .address else { return }
            selectedInfoType = infoType
            styleInfoDotsFor(selectedInfoType: selectedInfoType)
            reminderContainerView.isHidden = true
            addressContainerView.isHidden = false
        case .reminder:
            guard selectedInfoType != .reminder else { return }
            selectedInfoType = infoType
            styleInfoDotsFor(selectedInfoType: selectedInfoType)
            addressContainerView.isHidden = true
            reminderContainerView.isHidden = false
        }
    }
    
    func select(noteType: NoteType) {
        switch noteType {
        case .gifts:
            guard selectedNoteType != .gifts else { return }
            selectedNoteType = .gifts
            styleNoteDotsFor(selectedNoteType: selectedNoteType)
            populateNote(noteType: selectedNoteType)
        case .plans:
            guard selectedNoteType != .plans else { return }
            selectedNoteType = .plans
            styleNoteDotsFor(selectedNoteType: selectedNoteType)
            populateNote(noteType: selectedNoteType)
        case .other:
            guard selectedNoteType != .other else { return }
            selectedNoteType = .other
            styleNoteDotsFor(selectedNoteType: selectedNoteType)
            populateNote(noteType: selectedNoteType)
        }
    }
    
    // MARK: Private Helpers
    
    private func styleInfoDotsFor(selectedInfoType: InfoType) {
        self.selectedInfoType = selectedInfoType
        switch selectedInfoType {
        case .address:
            addressInfoDotView.setSelectedState(isSelected: true)
            reminderInfoDotView.setSelectedState(isSelected: false)
        case .reminder:
            reminderInfoDotView.setSelectedState(isSelected: true)
            addressInfoDotView.setSelectedState(isSelected: false)
        }
    }
    
    private func styleNoteDotsFor(selectedNoteType: NoteType) {
        self.selectedNoteType = selectedNoteType
        switch selectedNoteType {
        case .gifts:
            giftsNoteDotView.setSelectedState(isSelected: true)
            plansNoteDotView.setSelectedState(isSelected: false)
            otherNoteDotView.setSelectedState(isSelected: false)
        case .plans:
            giftsNoteDotView.setSelectedState(isSelected: false)
            plansNoteDotView.setSelectedState(isSelected: true)
            otherNoteDotView.setSelectedState(isSelected: false)
        case .other:
            giftsNoteDotView.setSelectedState(isSelected: false)
            plansNoteDotView.setSelectedState(isSelected: false)
            otherNoteDotView.setSelectedState(isSelected: true)
        }
    }
}

// MARK: - Populatable

extension EventDetailsView: Populatable {
    
    struct Content {
        let event: Event
        let daysBefore: ReminderDaysBefore?
        let timeOfDay: Date?
        let infoType: InfoType
        let noteType: NoteType
    }
    
    func populate(with content: Content) {
        let event = content.event
        self.event = event
        
        // Details
        
        populateDetails(event: event)
        styleDetails(eventType: event.eventType)
        
        // Info
        
        populateInfo(address: event.address)
        populateInfo(reminder: content.daysBefore, timeOfDay: content.timeOfDay)
        styleInfo(address: event.address, infoType: content.infoType, eventType: event.eventType)
        styleInfo(reminder: content.daysBefore, timeOfDay: content.timeOfDay, eventType: event.eventType)
        styleInfoDotsFor(selectedInfoType: content.infoType)
 
        // Notes
        
        populateNote(noteType: content.noteType)
        styleNote(eventType: content.event.eventType)
        styleNoteDotsFor(selectedNoteType: content.noteType)
    }
    
    // MARK: Private Helpers
    
    // Details
    
    private func populateDetails(event: Event) {
        inLabel.text = Constant.String.in
        daysLabel.text = event.daysAway
        
        switch event.eventType {
        case .birthday:
            isLabel.text = Constant.String.turns
        case .anniversary:
            isLabel.text = Constant.String.year
        default:
            return
        }
        
        ageLabel.text = event.numOfYears
        onLabel.text = Constant.String.on
        dateLabel.text = event.dayOfYear
    }
    
    private func styleDetails(eventType: EventType) {
        detailsContainerView.backgroundColor = eventType.color
        
        switch eventType {
        case .holiday, .other:
            ageStackView.isHidden = true
        default:
            return
        }
    }
    
    // Info
    
    private func populateInfo(address: Address?) {
        if address?.street == nil && address?.region == nil {
            addressLabelOne.text = Constant.String.addAddress
        } else {
            addressLabelOne.text = address?.street
            addressLabelTwo.text = address?.region
        }
    }
    
    private func styleInfo(address: Address?, infoType: InfoType, eventType: EventType) {
        if address?.street == nil && address?.region == nil {
            addressLabelOne.isHidden = false // Populate and show "Add Address"
            addressLabelTwo.isHidden = true
        } else {
            addressLabelOne.isHidden = address?.street == nil ? true : false
            addressLabelTwo.isHidden = address?.region == nil ? true : false
        }

        switch infoType {
        case .address:
            reminderContainerView.isHidden = true
            addressContainerView.isHidden = false
        case .reminder:
            addressContainerView.isHidden = true
            reminderContainerView.isHidden = false
        }
        
        addressInfoDotView.eventType = eventType
    }
    
    private func populateInfo(reminder: ReminderDaysBefore?, timeOfDay: Date?) {
        if
            let daysBefore = reminder,
            let timeOfDay = timeOfDay?.formatted("h:mm a")
        {
            reminderLabel.text = "\(daysBefore.pickerText)\n\(timeOfDay)"
        } else {
            reminderLabel.text = Constant.String.addReminder
        }
    }
    
    private func styleInfo(reminder: ReminderDaysBefore?, timeOfDay: Date?, eventType: EventType) {
        if
            reminder != nil,
            timeOfDay != nil
        {
            reminderIconImageView.image = Constant.Image.reminderSet
        } else {
            reminderIconImageView.image = Constant.Image.addReminder
        }
        
        if #available(iOS 13.0, *) {
            reminderEventImageView.image = eventType.image.withTintColor(.black)
        } else {
            tintColor = .black
        }
        
        reminderInfoDotView.eventType = eventType
    }
    
    private func populateNote(noteType: NoteType) {
        if
            let note = event?.note(forType: noteType),
            let subject = note.subject
        {
            noteTitleLabel.text = subject.capitalized
            noteDescriptionLabel.text = note.body ?? Constant.String.noDescription
            noteDescriptionLabel.textAlignment = .left
            switch UIDevice.type {
            case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                noteDescriptionLabel.font = FontType.avenirNextMedium(18).font
            default:
                noteDescriptionLabel.font = FontType.avenirNextMedium(22).font
            }

        } else {
            noteTitleLabel.text = "No \(noteType.rawValue.capitalized) Note"
            noteDescriptionLabel.text = "\(Constant.String.addNote) \(noteType.rawValue.capitalized)"
            noteDescriptionLabel.textAlignment = .center
            switch UIDevice.type {
            case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                noteDescriptionLabel.font = FontType.noteworthyBold(20).font
            default:
                noteDescriptionLabel.font = FontType.noteworthyBold(26).font
            }
        }
    }
    
    private func styleNote(eventType: EventType) {
        notesContainerView.backgroundColor = eventType.color
        
        giftsNoteDotView.eventType = eventType
        plansNoteDotView.eventType = eventType
        otherNoteDotView.eventType = eventType
    }
}
