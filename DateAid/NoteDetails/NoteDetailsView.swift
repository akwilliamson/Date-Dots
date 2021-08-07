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
    
    private var iconStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var noteIconImageView: NoteCircleImageView = {
        let dot = NoteCircleImageView(noteType: .gifts)
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.contentMode = .center
        return dot
    }()
    
    private var backgroundView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var noteDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = true
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var inputSubjectTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.autocorrectionType = .no
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
        textView.autocorrectionType = .no
        textView.backgroundColor = .compatibleSystemBackground
        textView.font = FontType.avenirNextDemiBold(20).font
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 5
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = true
        return textView
    }()
    
    // MARK: Properties
    
    weak var delegate: NoteDetailsViewDelegate?
    
    private var noteType: NoteType = .gifts
    
    // MARK: View Setup
    
    override func constructSubviewHierarchy() {
        super.constructSubviewHierarchy()
        
        addSubview(containerView)
            containerView.addArrangedSubview(headerStackView)
                headerStackView.addArrangedSubview(iconStackView)
                    iconStackView.addArrangedSubview(eventIconImageView)
                    iconStackView.addArrangedSubview(noteIconImageView)
                headerStackView.addArrangedSubview(eventNameLabel)
            containerView.addArrangedSubview(backgroundView)
                backgroundView.addSubview(noteDetailsStackView)
                    noteDetailsStackView.addArrangedSubview(inputSubjectTextField)
                    noteDetailsStackView.addArrangedSubview(inputDescriptionTextView)
    }
    
    override func constructLayout() {
        super.constructLayout()
        
        NSLayoutConstraint.activate([
            eventIconImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 35),
            eventIconImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5),
            eventIconImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5)
        ])
        NSLayoutConstraint.activate([
            eventNameLabel.heightAnchor.constraint(equalToConstant: 60),
            eventNameLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            eventNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            eventNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
        NSLayoutConstraint.activate([
            noteIconImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5),
            noteIconImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5)
        ])
        NSLayoutConstraint.activate([
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            inputSubjectTextField.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 30),
            inputSubjectTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            inputSubjectTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
            inputSubjectTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
        NSLayoutConstraint.activate([
            inputDescriptionTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            inputDescriptionTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
            inputDescriptionTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

extension NoteDetailsView: Populatable {
    
    // MARK: Content
    
    struct Content {
        let eventName: String
        let eventType: EventType
        let noteType: NoteType
        let subjectIsEmpty: Bool
        let descriptionIsEmpty: Bool
        let subject: String
        let description: String
    }
    
    func populate(with content: Content) {
        
        self.noteType = content.noteType
        
        // Background
        
        backgroundView.image = nil
        backgroundView.backgroundColor = content.eventType.color
        
        // Event Icon
        
        eventIconImageView.eventType = content.eventType
        eventIconImageView.setSelectedState(isSelected: true)
        
        // Name
        
        eventNameLabel.text = content.eventName
        
        // Note Type
        
        switch content.noteType {
        case .gifts: noteIconImageView.noteType = .gifts
        case .plans: noteIconImageView.noteType = .plans
        case .misc:  noteIconImageView.noteType = .misc
        }
        
        noteIconImageView.setSelectedState(isSelected: true)
        
        // Input Fields
        
        inputSubjectTextField.text = content.subject
        inputDescriptionTextView.text = content.description
        
        if content.subjectIsEmpty {
            inputSubjectTextField.textColor = .compatiblePlaceholderText
        } else {
            inputSubjectTextField.textColor = .compatibleLabel
        }
        
        if content.descriptionIsEmpty {
            inputDescriptionTextView.textColor = .compatiblePlaceholderText
        } else {
            inputDescriptionTextView.textColor = .compatibleLabel
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
            switch noteType {
            case .gifts: inputSubjectTextField.text = "Gift Ideas Title"
            case .plans: inputSubjectTextField.text = "Event Plans Title"
            case .misc:  inputSubjectTextField.text = "Misc Notes Title"
            }
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
            switch noteType {
            case .gifts: inputDescriptionTextView.text = "Gifts Ideas Description"
            case .plans: inputDescriptionTextView.text = "Event Plans Description"
            case .misc:  inputDescriptionTextView.text = "Misc Notes Description"
            }
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
