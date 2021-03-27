//
//  NoteDetailsView.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/24/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NoteDetailsViewDelegate: AnyObject {
    
    func didTapEventSelection()
    
    func textFieldDidBeginEditing()
    func textFieldDidChange(text: String?)
    func textFieldDidEndEditing()
    
    func textViewDidBeginEditing()
    func textViewDidChange(text: String?)
    func textViewDidEndEditing()
    
    func didTapViewEventDetails()
    func didTapDeleteNote()
}

class NoteDetailsView: BaseView {
    
    // MARK: UI
    
    private var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private var eventIconImageView: CircleImageView = {
        let imageView = CircleImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        return imageView
    }()
    
    private var eventNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = FontType.avenirNextDemiBold(35).font
        return label
    }()
    
    private var eventSelectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapEventSelectionButton), for: .touchUpInside)
        button.setTitle("Choose Event", for: .normal)
        button.titleLabel?.font = FontType.avenirNextMedium(25).font
        button.setTitleColor(.compatibleLabel, for: .normal)
        button.layer.borderColor = UIColor.compatibleLabel.cgColor
        button.layer.borderWidth = 5
        button.clipsToBounds = true
        return button
    }()
    
    private var selectedEventEditButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(didTapEventSelectionButton), for: .touchUpInside)
        button.setImage(UIImage(named: "edit"), for: .normal)
        return button
    }()
    
    private var noteTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var giftsDot: NoteCircleImageView = {
        let dot = NoteCircleImageView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.contentMode = .center
        dot.setImage(for: .gifts)
        dot.downsizeImage(to: CGSize(width: UIScreen.main.bounds.width/16, height: UIScreen.main.bounds.width/13))
        return dot
    }()
    
    private lazy var plansDot: NoteCircleImageView = {
        let dot = NoteCircleImageView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.contentMode = .center
        dot.tintColor = UIColor.compatibleSystemGray3
        dot.layer.borderColor = UIColor.compatibleSystemGray3.cgColor
        dot.layer.borderWidth = 5
        dot.setImage(for: .plans)
        dot.downsizeImage(to: CGSize(width: UIScreen.main.bounds.width/11, height: UIScreen.main.bounds.width/11))
        return dot
    }()
    
    private lazy var otherDot: NoteCircleImageView = {
        let dot = NoteCircleImageView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.contentMode = .center
        dot.tintColor = UIColor.compatibleSystemGray3
        dot.layer.borderColor = UIColor.compatibleSystemGray3.cgColor
        dot.layer.borderWidth = 5
        dot.setImage(for: .other)
        dot.downsizeImage(to: CGSize(width: UIScreen.main.bounds.width/12, height: UIScreen.main.bounds.width/12))
        return dot
    }()
    
    private var backgroundView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var inputSubjectTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.backgroundColor = .compatibleSystemBackground
        textField.font = FontType.avenirNextDemiBold(24).font
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 0.5
        textField.textAlignment = .center
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private lazy var inputDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.backgroundColor = .compatibleSystemBackground
        textView.font = FontType.avenirNextDemiBold(20).font
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    private var buttonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var viewEventDetailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.addTarget(self, action: #selector(didTapViewEventDetailsButton), for: .touchUpInside)
        button.setImage(UIImage(named: "calendar"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .white
        button.layer.borderWidth = 5
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var deleteNoteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapDeleteNoteButton), for: .touchUpInside)
        button.setImage(UIImage(named: "trash"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .white
        button.layer.borderWidth = 5
        return button
    }()
    
    // MARK: Properties
    
    weak var delegate: NoteDetailsViewDelegate?
    
    // MARK: Lifecycle
    
    override func constructSubviewHierarchy() {
        super.constructSubviewHierarchy()
        
        addSubview(containerView)
        containerView.addArrangedSubview(headerStackView)
        headerStackView.addArrangedSubview(eventIconImageView)
        headerStackView.setCustomSpacing(25, after: eventIconImageView)
        headerStackView.addArrangedSubview(eventNameLabel)
        headerStackView.setCustomSpacing(25, after: eventNameLabel)
        headerStackView.addArrangedSubview(selectedEventEditButton)
        headerStackView.setCustomSpacing(25, after: selectedEventEditButton)
        headerStackView.addArrangedSubview(eventSelectionButton)
        headerStackView.setCustomSpacing(25, after: eventSelectionButton)
        headerStackView.addArrangedSubview(noteTypeStackView)
        noteTypeStackView.addArrangedSubview(giftsDot)
        noteTypeStackView.addArrangedSubview(plansDot)
        noteTypeStackView.addArrangedSubview(otherDot)
        containerView.setCustomSpacing(25, after: headerStackView)
        containerView.addArrangedSubview(backgroundView)
        backgroundView.addSubview(inputStackView)
        inputStackView.addArrangedSubview(inputSubjectTextField)
        inputStackView.addArrangedSubview(inputDescriptionTextView)
        backgroundView.addSubview(buttonContainerView)
        buttonContainerView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(viewEventDetailsButton)
        buttonStackView.addArrangedSubview(deleteNoteButton)
    }
    
    override func constructLayout() {
        super.constructLayout()
        
        NSLayoutConstraint.activate([
            eventIconImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            eventIconImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            eventIconImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5),
            eventIconImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5)
        ])
        NSLayoutConstraint.activate([
            eventNameLabel.heightAnchor.constraint(equalToConstant: 30),
            eventNameLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            selectedEventEditButton.heightAnchor.constraint(equalToConstant: 44),
            selectedEventEditButton.widthAnchor.constraint(equalToConstant: 44),
            selectedEventEditButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            eventSelectionButton.heightAnchor.constraint(equalToConstant: 60),
            eventSelectionButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            eventSelectionButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        NSLayoutConstraint.activate([
            giftsDot.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/6),
            giftsDot.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/6)
        ])
        NSLayoutConstraint.activate([
            inputSubjectTextField.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 30),
            inputSubjectTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            inputSubjectTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
            inputSubjectTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            backgroundView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            inputDescriptionTextView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/5)
        ])
        NSLayoutConstraint.activate([
            buttonContainerView.topAnchor.constraint(equalTo: inputDescriptionTextView.bottomAnchor, constant: 30),
            buttonContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            buttonContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            buttonContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: buttonContainerView.centerXAnchor),
            buttonStackView.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            viewEventDetailsButton.heightAnchor.constraint(equalTo: viewEventDetailsButton.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            deleteNoteButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5),
            deleteNoteButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5)
        ])
    }
    
    @objc
    func didTapEventSelectionButton() {
        endEditing(true)
        delegate?.didTapEventSelection()
    }
    
    @objc
    func didTapViewEventDetailsButton() {
        delegate?.didTapViewEventDetails()
    }
    
    @objc
    func didTapDeleteNoteButton() {
        delegate?.didTapDeleteNote()
    }
}

extension NoteDetailsView: Populatable {
    
    // MARK: Content
    
    struct Content {
        let isNewNote: Bool
        let hasEvent: Bool
        let isEditable: Bool
        let eventType: EventType?
        let name: String?
        let noteType: NoteType
        let subject: String
        let description: String
    }
    
    func populate(with content: Content) {
        
        // Background
        
        if content.isNewNote && !content.hasEvent {
            backgroundView.image = UIImage(named: "no-event-background")
        } else {
            backgroundView.image = nil
            backgroundView.backgroundColor = content.eventType?.color
        }
        
        // Event Icon
        
        if let eventType = content.eventType {
            eventIconImageView.style(for: eventType)
            let imageSize = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
            eventIconImageView.downsizeImage(to: imageSize)
        } else {
            eventIconImageView.image = UIImage(named: "question-mark")
            let imageSize = CGSize(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/5)
            eventIconImageView.downsizeImage(to: imageSize)
        }
        
        // Event Selection
        
        eventSelectionButton.isHidden = content.hasEvent
        selectedEventEditButton.isHidden = !content.isEditable || !content.hasEvent
        
        // Name
        
        if let name = content.name {
            eventNameLabel.text = name
            eventNameLabel.isHidden = false
        } else {
            eventNameLabel.isHidden = true
        }
        
        // Note Type
        
        switch content.noteType {
        case .gifts:
            giftsDot.setSelectedState(isSelected: true, color: content.eventType?.color)
            plansDot.setSelectedState(isSelected: false)
            otherDot.setSelectedState(isSelected: false)
        case .plans:
            giftsDot.setSelectedState(isSelected: false)
            plansDot.setSelectedState(isSelected: true, color: content.eventType?.color)
            otherDot.setSelectedState(isSelected: false)
        case .other:
            giftsDot.setSelectedState(isSelected: false)
            plansDot.setSelectedState(isSelected: false)
            otherDot.setSelectedState(isSelected: true, color: content.eventType?.color)
        }
        
        // Input Fields
        
        inputSubjectTextField.text = content.subject
        inputDescriptionTextView.text = content.description
        
        if content.isNewNote {
            inputSubjectTextField.textColor = .compatiblePlaceholderText
            inputDescriptionTextView.textColor = .compatiblePlaceholderText
        } else {
            inputSubjectTextField.textColor = .compatibleLabel
            inputDescriptionTextView.textColor = .compatibleLabel
        }
        
        if content.isEditable {
            inputSubjectTextField.isUserInteractionEnabled = true
            inputDescriptionTextView.isEditable = true
        } else {
            inputSubjectTextField.isUserInteractionEnabled = false
            inputDescriptionTextView.isEditable = false
        }
        
        // Bottom Buttons
        
        viewEventDetailsButton.isHidden = content.isNewNote && !content.hasEvent
        deleteNoteButton.isHidden = content.isNewNote
        
        // Layout & Styling
        
        [eventSelectionButton, selectedEventEditButton, viewEventDetailsButton, deleteNoteButton].forEach { button in
            button.layoutIfNeeded()
            button.layer.cornerRadius = button.bounds.height/2
        }
    }
    
    // MARK: Public Interface
    
    func startEditTextField(isPlaceholder: Bool) {
        let cursorPosition: UITextPosition
        
        if isPlaceholder {
            cursorPosition = inputSubjectTextField.beginningOfDocument
            inputSubjectTextField.text = nil
        } else {
            cursorPosition = inputSubjectTextField.endOfDocument
        }
        
        inputSubjectTextField.textColor = UIColor.compatibleLabel
        inputSubjectTextField.selectedTextRange = inputSubjectTextField.textRange(from: cursorPosition, to: cursorPosition)
    }
    
    func endEditTextField(isPlaceholder: Bool) {
        if isPlaceholder {
            inputSubjectTextField.textColor = UIColor.compatiblePlaceholderText
            inputSubjectTextField.text = "Note Title"
        }
    }
    
    func startEditTextView(isPlaceholder: Bool) {
        let cursorPosition: UITextPosition
        
        if isPlaceholder {
            cursorPosition = inputDescriptionTextView.beginningOfDocument
            inputDescriptionTextView.text = nil
        } else {
            cursorPosition = inputDescriptionTextView.endOfDocument
        }

        inputDescriptionTextView.textColor = UIColor.compatibleLabel
        inputDescriptionTextView.selectedTextRange = inputDescriptionTextView.textRange(from: cursorPosition, to: cursorPosition)
    }
    
    func endEditTextView(isPlaceholder: Bool) {
        if isPlaceholder {
            inputDescriptionTextView.textColor = UIColor.compatiblePlaceholderText
            inputDescriptionTextView.text = "Note Details"
        }
    }
}

// MARK: - UITextFieldDelegate

extension NoteDetailsView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.textFieldDidChange(text: textField.text)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputSubjectTextField.resignFirstResponder()
        inputDescriptionTextView.becomeFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate

extension NoteDetailsView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange(text: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewDidEndEditing()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        inputDescriptionTextView.resignFirstResponder()
        return true
    }
}
