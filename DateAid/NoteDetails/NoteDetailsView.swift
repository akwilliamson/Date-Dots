//
//  NoteDetailsView.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/24/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NoteDetailsViewDelegate: AnyObject {
    
    func textFieldDidBeginEditing()
    func textFieldDidChange(text: String?)
    func textFieldDidEndEditing()
    
    func textViewDidBeginEditing()
    func textViewDidChange(text: String?)
    func textViewDidEndEditing()
    
    func didTapDeleteNote()
}

class NoteDetailsView: BaseView {
    
    // MARK: UI
    
    private var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var eventIconImageView: EventCircleImageView = {
        // Default to birthday for initializer, set for real in populatable
        let imageView = EventCircleImageView(eventType: .birthday)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = FontType.avenirNextDemiBold(35).font
        return label
    }()
    
    private var noteTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var giftsDot: NoteCircleImageView = {
        let dot = NoteCircleImageView(noteType: .gifts)
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.contentMode = .center
        return dot
    }()
    
    private lazy var plansDot: NoteCircleImageView = {
        let dot = NoteCircleImageView(noteType: .plans)
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.contentMode = .center
        return dot
    }()
    
    private lazy var otherDot: NoteCircleImageView = {
        let dot = NoteCircleImageView(noteType: .other)
        dot.translatesAutoresizingMaskIntoConstraints = false
        return dot
    }()
    
    private var backgroundView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var deleteNoteButton: RoundedButton = {
        let button = RoundedButton()
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
    
    // MARK: View Setup
    
    override func constructSubviewHierarchy() {
        super.constructSubviewHierarchy()
        
        addSubview(containerView)
            containerView.addArrangedSubview(headerStackView)
                headerStackView.addArrangedSubview(eventIconImageView)
                headerStackView.addArrangedSubview(eventNameLabel)
                headerStackView.addArrangedSubview(noteTypeStackView)
                    noteTypeStackView.addArrangedSubview(giftsDot)
                    noteTypeStackView.addArrangedSubview(plansDot)
                    noteTypeStackView.addArrangedSubview(otherDot)
            containerView.addArrangedSubview(backgroundView)
                backgroundView.addSubview(inputStackView)
                    inputStackView.addArrangedSubview(inputSubjectTextField)
                    inputStackView.addArrangedSubview(inputDescriptionTextView)
                backgroundView.addSubview(buttonContainerView)
                    buttonContainerView.addSubview(deleteNoteButton)
    }
    
    override func constructLayout() {
        super.constructLayout()
        
        NSLayoutConstraint.activate([
            eventIconImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 36),
            eventIconImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            eventIconImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5),
            eventIconImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5)
        ])
        NSLayoutConstraint.activate([
            eventNameLabel.heightAnchor.constraint(equalToConstant: 60),
            eventNameLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
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
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
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
            buttonContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            deleteNoteButton.centerXAnchor.constraint(equalTo: buttonContainerView.centerXAnchor),
            deleteNoteButton.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor),
            deleteNoteButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5),
            deleteNoteButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5)
        ])
    }
    
    // MARK: Actions
    
    @objc
    func didTapDeleteNoteButton() {
        delegate?.didTapDeleteNote()
    }
}

extension NoteDetailsView: Populatable {
    
    // MARK: Content
    
    struct Content {
        let name: String
        let eventType: EventType
        let noteType: NoteType
        let isNewNote: Bool
        let isEditable: Bool
        let subject: String
        let description: String
    }
    
    func populate(with content: Content) {
        
        // Background
        
        backgroundView.image = nil
        backgroundView.backgroundColor = content.eventType.color
        
        // Event Icon
        
        eventIconImageView.eventType = content.eventType
        eventIconImageView.setSelectedState(isSelected: true)
        
        // Name
        
        eventNameLabel.text = content.name
        
        // Note Type
        
        switch content.noteType {
        case .gifts:
            giftsDot.setSelectedState(isSelected: true)
            plansDot.setSelectedState(isSelected: false)
            otherDot.setSelectedState(isSelected: false)
        case .plans:
            giftsDot.setSelectedState(isSelected: false)
            plansDot.setSelectedState(isSelected: true)
            otherDot.setSelectedState(isSelected: false)
        case .other:
            giftsDot.setSelectedState(isSelected: false)
            plansDot.setSelectedState(isSelected: false)
            otherDot.setSelectedState(isSelected: true)
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
    }
    
    // MARK: Public Interface
    
    func beginEdit() {
        inputSubjectTextField.isUserInteractionEnabled = true
        inputDescriptionTextView.isEditable = true
        inputSubjectTextField.becomeFirstResponder()
    }
    
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
