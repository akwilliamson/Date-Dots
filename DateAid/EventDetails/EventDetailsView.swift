//
//  EventDetailsView.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/13/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventDetailsViewDelegate: AnyObject {
    
    func didSelectAddress()
    func didSelectReminder()
    func didSelectInfoType(_ infoType: InfoType)
    func didSelectNoteType(_ noteType: NoteType)
    func didSelectNoteView(_ note: Note?, noteType: NoteType?)
}

class EventDetailsView: BaseView {
    
    // MARK: Constants
    
    private enum Constant {
        enum String {
            static let turns = "turns"
            static let years = "years"
            static let `in` = "in"
            static let on = "on"
            static let addStreet = "Add Street"
            static let addRegion = "Add City/State/Zip"
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
    
    // Details - Age Fallback
    
    private let fallbackEventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
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
    
    private lazy var addressContainerView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "envelope")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressPressed))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private let addressLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let streetLabel: UILabel = {
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
    
    private let regionLabel: UILabel = {
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
    
    private lazy var reminderContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
        view.layer.borderColor = UIColor.compatibleSystemBackground.cgColor
        view.layer.cornerRadius = 5
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reminderPressed))
        view.addGestureRecognizer(tapGesture)
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
    
    private lazy var notesContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(notePressed))
        view.addGestureRecognizer(tapGesture)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let noteTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
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
        label.isUserInteractionEnabled = false
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
        let dotView = NoteCircleImageView(noteType: .misc)
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
                detailsStackView.addArrangedSubview(fallbackEventImageView)
                detailsStackView.addArrangedSubview(ageStackView)
                    ageStackView.addArrangedSubview(isLabel)
                    ageStackView.addArrangedSubview(ageLabel)
                detailsStackView.addArrangedSubview(dateStackView)
                    dateStackView.addArrangedSubview(onLabel)
                    dateStackView.addArrangedSubview(dateLabel)
        containerStackView.setCustomSpacing(36, after: detailsContainerView)
        containerStackView.addArrangedSubview(addressContainerView)
            addressContainerView.addSubview(addressLabelStackView)
                addressLabelStackView.addArrangedSubview(streetLabel)
                addressLabelStackView.addArrangedSubview(regionLabel)
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
            addressContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addressContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addressContainerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/6)
        ])
        NSLayoutConstraint.activate([
            reminderContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            reminderContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
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
            notesContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            notesContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
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
    func addressPressed() {
        delegate?.didSelectAddress()
    }
    
    @objc
    func reminderPressed() {
        delegate?.didSelectReminder()
    }
    
    @objc
    func addressDotPressed() {
        delegate?.didSelectInfoType(.address)
    }
    
    @objc
    func reminderDotPressed() {
        delegate?.didSelectInfoType(.reminder)
    }
    
    @objc
    func notePressed() {
        let note = event?.note(forType: selectedNoteType)
        delegate?.didSelectNoteView(note, noteType: selectedNoteType)
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
        delegate?.didSelectNoteType(.misc)
    }
    
    // MARK: Interface
    
    func select(infoType: InfoType) {
        guard selectedInfoType != infoType else { return }
        
        selectInfoType(infoType)
    }
    
    func select(noteType: NoteType) {
        guard selectedNoteType != noteType else { return }
        
        selectNoteType(noteType)
        populateNote(noteType: noteType)
    }
    
    func updateReminder(text: String) {
        reminderLabel.text = text
    }
    
    // MARK: Private Helpers
    
    private func selectInfoType(_ infoType: InfoType) {
        self.selectedInfoType = infoType
        
        switch selectedInfoType {
        case .address:
            addressInfoDotView.setSelectedState(isSelected: true)
            reminderInfoDotView.setSelectedState(isSelected: false)
            addressContainerView.isHidden = false
            reminderContainerView.isHidden = true
        case .reminder:
            addressInfoDotView.setSelectedState(isSelected: false)
            reminderInfoDotView.setSelectedState(isSelected: true)
            addressContainerView.isHidden = true
            reminderContainerView.isHidden = false
        }
    }
    
    private func selectNoteType(_ noteType: NoteType) {
        self.selectedNoteType = noteType
        
        switch selectedNoteType {
        case .gifts:
            giftsNoteDotView.setSelectedState(isSelected: true)
            plansNoteDotView.setSelectedState(isSelected: false)
            otherNoteDotView.setSelectedState(isSelected: false)
        case .plans:
            giftsNoteDotView.setSelectedState(isSelected: false)
            plansNoteDotView.setSelectedState(isSelected: true)
            otherNoteDotView.setSelectedState(isSelected: false)
        case .misc:
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
        let scheduleText: String?
        let infoType: InfoType
        let noteType: NoteType
    }
    
    func populate(with content: Content) {
        let event = content.event
        self.event = event
        
        populateDetails(event: event)
        
        populateAddress(event.address?.street, region: event.address?.region)
        populateReminder(event.eventType, text: content.scheduleText)
        
        styleInfoButtons(eventType: event.eventType)
        selectInfoType(content.infoType)
        
        populateNote(noteType: content.noteType)
        styleNote(eventType: event.eventType)
        
        selectNoteType(content.noteType)
    }
    
    // MARK: Private Helpers
    
    // Details
    
    private func populateDetails(event: Event) {
        
        // In
        
        inLabel.text = Constant.String.in
        daysLabel.text = event.daysAway
        
        // Is
        
        switch event.eventType {
        case .birthday:
            if event.date.year == 2100 {
                ageStackView.isHidden = true
                fallbackEventImageView.image = event.eventType.image
            } else {
                fallbackEventImageView.isHidden = true
                isLabel.text = Constant.String.turns
                ageLabel.text = event.numOfYears
            }
        case .anniversary:
            if event.date.year == 2100 {
                ageStackView.isHidden = true
                fallbackEventImageView.image = event.eventType.image
            } else {
                fallbackEventImageView.isHidden = true
                isLabel.text = Constant.String.years
                ageLabel.text = event.numOfYears
            }
        case .custom:
            fallbackEventImageView.image = event.eventType.image
        case .other:
            fallbackEventImageView.image = event.eventType.image
        }
        
        // On
        
        onLabel.text = Constant.String.on
        dateLabel.text = event.dayOfYear
        
        detailsContainerView.backgroundColor = event.eventType.color
    }
    
    // Address
    
    private func populateAddress(_ street: String?, region: String?) {
        streetLabel.text = street ?? Constant.String.addStreet
        regionLabel.text = region ?? Constant.String.addRegion
    }
    
    // Reminder
    
    private func populateReminder(_ eventType: EventType, text: String?) {
        reminderEventImageView.image = eventType.image.withTintColor(.black)
        
        if let text = text {
            reminderLabel.text = text
            reminderIconImageView.image = Constant.Image.reminderSet
        } else {
            reminderLabel.text = Constant.String.addReminder
            reminderIconImageView.image = Constant.Image.addReminder
        }
    }
    
    private func styleInfoButtons(eventType: EventType) {
        addressInfoDotView.eventType = eventType
        reminderInfoDotView.eventType = eventType
    }
    
    // Notes
    
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
