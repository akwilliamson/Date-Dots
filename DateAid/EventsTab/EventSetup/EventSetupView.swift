//
//  EventSetupView.swift
//  Date Dots
//
//  Created by Aaron Williamson on 5/4/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

enum EventSetupInputType {
    case firstName
    case lastName
    case addressOne
    case addressTwo
}

protocol EventSetupViewDelegate {
    
    func didBeginEditingFor(inputType: EventSetupInputType, currentText: String?, _ completion: (String?, UIColor) -> Void)
    func didEndEditingFor(inputType: EventSetupInputType, currentText: String?, _ completion: (String?, UIColor) -> Void)
    func textDidChange(inputType: EventSetupInputType, currentText: String?)
    func eventTypeSelected(eventType: EventType, isSelected: Bool)
    func datePickerValueChangedTo(date: Date)
}

class EventSetupView: BaseView {
    
    // MARK: Content
    
    struct Content {
        let whoText: String
        let whatText: String
        let whenText: String
        let whereText: String
        let whyText: String
        let firstNameText: String?
        let firstNamePlaceholderText: String?
        let lastNameText: String?
        let lastNamePlaceholderText: String?
        let addressOneText: String?
        let addressOnePlaceholderText: String?
        let addressTwoText: String?
        let addressTwoPlaceholderText: String?
        let whyDescriptionText: String
        let date: Date?
        let eventType: EventType?
    }
    
    // MARK: UI
    
    private let containerStackView: UIStackView
    // Who
    private let whoLabel: UILabel
    private let whoStackView: UIStackView
    private let firstNameTextField: PaddedTextField
    private let lastNameTextField: PaddedTextField
    // What
    private let whatLabel: UILabel
    private let whatStackView: UIStackView
    private let birthdayDot: EventCircleImageView
    private let anniversaryDot: EventCircleImageView
    private let holidayDot: EventCircleImageView
    private let otherDot: EventCircleImageView
    // When
    private let whenLabel: UILabel
    private let whenDatePicker: UIDatePicker
    // Where
    private let whereLabel: UILabel
    private let whereStackView: UIStackView
    private let addressOneTextField: PaddedTextField
    private let addressTwoTextField: PaddedTextField
    // Why
    private let whyLabel: UILabel
    private let whyDescriptionLabel: UILabel
    
    // MARK: Properties
    
    var delegate: EventSetupViewDelegate?
    
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
            label.textAlignment = .center
            switch UIDevice.type {
            case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                label.font = FontType.noteworthyBold(12).font
            default:
                label.font = FontType.noteworthyBold(16).font
            }
            return label
        }()
        
        whoStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            return stackView
        }()
        
        firstNameTextField = {
            let textField = PaddedTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            switch UIDevice.type {
            case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                textField.font = FontType.avenirNextDemiBold(18).font
            default:
                textField.font = FontType.avenirNextDemiBold(22).font
            }
            textField.textColor = .compatiblePlaceholderText
            textField.returnKeyType = .done
            textField.addTopBorder(with: .compatiblePlaceholderText, andWidth: 3)
            textField.addLeftBorder(with: .compatiblePlaceholderText, andWidth: 3)
            textField.addRightBorder(with: .compatiblePlaceholderText, andWidth: 3)
            textField.addBottomBorder(with: .compatiblePlaceholderText, andWidth: 3)
            return textField
        }()
        
        lastNameTextField = {
            let textField = PaddedTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            switch UIDevice.type {
            case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                textField.font = FontType.avenirNextDemiBold(18).font
            default:
                textField.font = FontType.avenirNextDemiBold(22).font
            }
            textField.textColor = .compatiblePlaceholderText
            textField.returnKeyType = .done
            textField.addLeftBorder(with: .compatiblePlaceholderText, andWidth: 3)
            textField.addRightBorder(with: .compatiblePlaceholderText, andWidth: 3)
            textField.addBottomBorder(with: .compatiblePlaceholderText, andWidth: 3)
            return textField
        }()
        
        whatLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            switch UIDevice.type {
            case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                label.font = FontType.noteworthyBold(12).font
            default:
                label.font = FontType.noteworthyBold(16).font
            }
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
            let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
            let imageView = EventCircleImageView(eventType: .birthday, scaledSize: size)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isUserInteractionEnabled = true
            return imageView
        }()
        
        anniversaryDot = {
            let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
            let imageView = EventCircleImageView(eventType: .anniversary, scaledSize: size)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isUserInteractionEnabled = true
            return imageView
        }()
        
        holidayDot = {
            let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
            let imageView = EventCircleImageView(eventType: .holiday, scaledSize: size)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isUserInteractionEnabled = true
            return imageView
        }()
        
        otherDot = {
            let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
            let imageView = EventCircleImageView(eventType: .other, scaledSize: size)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isUserInteractionEnabled = true
            return imageView
        }()
        
        whenLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            switch UIDevice.type {
            case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                label.font = FontType.noteworthyBold(12).font
            default:
                label.font = FontType.noteworthyBold(16).font
            }
            return label
        }()
        
        whenDatePicker = {
            let datePicker = UIDatePicker()
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            datePicker.minimumDate = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1))
            datePicker.maximumDate = Date()
            datePicker.datePickerMode = .date
            if #available(iOS 14, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
            return datePicker
        }()
        
        whereLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            switch UIDevice.type {
            case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                label.font = FontType.noteworthyBold(12).font
            default:
                label.font = FontType.noteworthyBold(16).font
            }
            return label
        }()
        
        whereStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            return stackView
        }()
        
        addressOneTextField = {
            let textField = PaddedTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            switch UIDevice.type {
            case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                textField.font = FontType.avenirNextDemiBold(18).font
            default:
                textField.font = FontType.avenirNextDemiBold(22).font
            }
            textField.textColor = .compatiblePlaceholderText
            textField.returnKeyType = .done
            textField.addTopBorder(with: .compatiblePlaceholderText, andWidth: 3)
            textField.addLeftBorder(with: .compatiblePlaceholderText, andWidth: 3)
            textField.addRightBorder(with: .compatiblePlaceholderText, andWidth: 3)
            textField.addBottomBorder(with: .compatiblePlaceholderText, andWidth: 3)
            return textField
        }()
        
        addressTwoTextField = {
            let textField = PaddedTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            switch UIDevice.type {
            case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                textField.font = FontType.avenirNextDemiBold(18).font
            default:
                textField.font = FontType.avenirNextDemiBold(22).font
            }
            textField.textColor = .compatiblePlaceholderText
            textField.returnKeyType = .done
            textField.addLeftBorder(with: .compatiblePlaceholderText, andWidth: 3)
            textField.addRightBorder(with: .compatiblePlaceholderText, andWidth: 3)
            textField.addBottomBorder(with: .compatiblePlaceholderText, andWidth: 3)
            return textField
        }()
        
        whyLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            switch UIDevice.type {
            case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                label.font = FontType.noteworthyBold(12).font
            default:
                label.font = FontType.noteworthyBold(16).font
            }
            return label
        }()
        
        whyDescriptionLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            switch UIDevice.type {
            case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
                label.font = FontType.avenirNextDemiBold(20).font
            default:
                label.font = FontType.avenirNextDemiBold(25).font
            }
            return label
        }()
        
        super.init(frame: frame)

        configureView()
    }
    
    // MARK: Lifecycle
    
    private func configureView() {
        backgroundColor = .compatibleSystemBackground
    }
    
    override func constructSubviewHierarchy() {
        
        let customSpacing: CGFloat
        let specialSpacing: CGFloat
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            customSpacing = 8
            specialSpacing = 4
        default:
            customSpacing = 12
            specialSpacing = 12
        }
        
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(whoLabel)
        containerStackView.setCustomSpacing(specialSpacing, after: whoLabel)
        containerStackView.addArrangedSubview(whoStackView)
        containerStackView.setCustomSpacing(customSpacing, after: whoStackView)
        whoStackView.addArrangedSubview(firstNameTextField)
        whoStackView.addArrangedSubview(lastNameTextField)
        containerStackView.setCustomSpacing(customSpacing, after: lastNameTextField)
        containerStackView.addArrangedSubview(whatLabel)
        containerStackView.setCustomSpacing(specialSpacing, after: whatLabel)
        containerStackView.addArrangedSubview(whatStackView)
        whatStackView.addArrangedSubview(birthdayDot)
        whatStackView.addArrangedSubview(anniversaryDot)
        whatStackView.addArrangedSubview(holidayDot)
        whatStackView.addArrangedSubview(otherDot)
        containerStackView.setCustomSpacing(customSpacing, after: whatStackView)
        containerStackView.addArrangedSubview(whenLabel)
        containerStackView.setCustomSpacing(specialSpacing, after: whenLabel)
        containerStackView.addArrangedSubview(whenDatePicker)
        containerStackView.setCustomSpacing(customSpacing, after: whenDatePicker)
        containerStackView.addArrangedSubview(whereLabel)
        containerStackView.setCustomSpacing(specialSpacing, after: whereLabel)
        containerStackView.addArrangedSubview(whereStackView)
        whereStackView.addArrangedSubview(addressOneTextField)
        whereStackView.addArrangedSubview(addressTwoTextField)
        containerStackView.setCustomSpacing(customSpacing, after: whereStackView)
        containerStackView.addArrangedSubview(whyLabel)
        containerStackView.setCustomSpacing(specialSpacing, after: whyLabel)
        containerStackView.addArrangedSubview(whyDescriptionLabel)
    }
    
    override func constructLayout() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            NSLayoutConstraint.activate([
                whoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
                firstNameTextField.heightAnchor.constraint(equalToConstant: 30),
                lastNameTextField.heightAnchor.constraint(equalToConstant: 30),
                birthdayDot.heightAnchor.constraint(equalTo: birthdayDot.widthAnchor),
                birthdayDot.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor, constant: 20),
                otherDot.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor, constant: -20),
                addressOneTextField.heightAnchor.constraint(equalToConstant: 30),
                addressTwoTextField.heightAnchor.constraint(equalToConstant: 30),
                whenDatePicker.heightAnchor.constraint(equalToConstant: 80),
                whyDescriptionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            ])
        default:
            NSLayoutConstraint.activate([
                whoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
                firstNameTextField.heightAnchor.constraint(equalToConstant: 40),
                lastNameTextField.heightAnchor.constraint(equalToConstant: 40),
                addressOneTextField.heightAnchor.constraint(equalToConstant: 40),
                addressTwoTextField.heightAnchor.constraint(equalToConstant: 40),
                birthdayDot.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/6),
                birthdayDot.heightAnchor.constraint(equalTo: birthdayDot.widthAnchor),
                whenDatePicker.heightAnchor.constraint(equalToConstant: 100),
                whyDescriptionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
        }
    }
}

// MARK: - Populatable

extension EventSetupView: Populatable {
    
    func populate(with content: Content) {
        whoLabel.text = content.whoText
        whatLabel.text = content.whatText
        whenLabel.text = content.whenText
        whereLabel.text = content.whereText
        whyLabel.text = content.whyText
        whyDescriptionLabel.text = content.whyDescriptionText
        
        if let firstNameText = content.firstNameText {
            firstNameTextField.text = firstNameText
            firstNameTextField.textColor = .compatibleLabel
        } else {
            firstNameTextField.text = content.firstNamePlaceholderText
        }
        
        if let lastNameText = content.lastNameText {
            lastNameTextField.text = lastNameText
            lastNameTextField.textColor = .compatibleLabel
        } else {
            lastNameTextField.text = content.lastNamePlaceholderText
        }
        
        if let addressOneText = content.addressOneText {
            addressOneTextField.text = addressOneText
            addressOneTextField.textColor = .compatibleLabel
        } else {
            addressOneTextField.text = content.addressOnePlaceholderText
        }
        
        if let addressTwoText = content.addressTwoText {
            addressTwoTextField.text = addressTwoText
            addressTwoTextField.textColor = .compatibleLabel
        } else {
            addressTwoTextField.text = content.addressTwoPlaceholderText
        }
        
        if let date = content.date {
            whenDatePicker.date = date
        } else {
            let currentDate = Calendar.current.dateComponents([.month, .day], from: Date())
            let defaultComponents = DateComponents(year: 2000, month: currentDate.month, day: currentDate.day)
            let defaultDate = Calendar.current.date(from: defaultComponents) ?? Date()
            whenDatePicker.setDate(defaultDate, animated: false)
        }
        
        if let eventType = content.eventType {
            switch eventType {
            case .birthday:
                birthdayDot.setSelectedState(isSelected: true)
            case .anniversary:
                anniversaryDot.setSelectedState(isSelected: true)
            case .holiday:
                holidayDot.setSelectedState(isSelected: true)
            case .other:
                otherDot.setSelectedState(isSelected: true)
            }
        }
        
        birthdayDot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:))))
        anniversaryDot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:))))
        holidayDot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:))))
        otherDot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:))))
        
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addressOneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addressTwoTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        whenDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        addressOneTextField.delegate = self
        addressTwoTextField.delegate = self
    }
    
    @objc
    func textFieldDidChange(_ sender: PaddedTextField) {
        guard let inputType = getInputTypeForTextField(sender) else { return }
        delegate?.textDidChange(inputType: inputType, currentText: sender.text)
    }
    
    @objc
    func datePickerValueChanged(_ sender: UIDatePicker) {
        delegate?.datePickerValueChangedTo(date: sender.date)
    }
    
    @objc
    func dotPressed(_ sender: UITapGestureRecognizer) {
        guard let iconImageView = sender.view as? EventCircleImageView else { return }
        
        let isCurrentlySelected = iconImageView.isSelected
        delegate?.eventTypeSelected(eventType: iconImageView.eventType, isSelected: !isCurrentlySelected)
        
        if isCurrentlySelected {
            iconImageView.setSelectedState(isSelected: false)
        } else {
            switch iconImageView {
            case birthdayDot:
                [anniversaryDot, holidayDot, otherDot].forEach { $0.setSelectedState(isSelected: false) }
            case anniversaryDot:
                [birthdayDot, holidayDot, otherDot].forEach { $0.setSelectedState(isSelected: false) }
            case holidayDot:
                [birthdayDot, anniversaryDot, otherDot].forEach { $0.setSelectedState(isSelected: false) }
            case otherDot:
                [birthdayDot, anniversaryDot, holidayDot].forEach { $0.setSelectedState(isSelected: false) }
            default:
                return
            }
            
            iconImageView.setSelectedState(isSelected: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension EventSetupView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let inputType = getInputTypeForTextField(textField) else { return }
        
        delegate?.didBeginEditingFor(inputType: inputType, currentText: textField.text) { text, textColor in
            textField.text = text
            textField.textColor = textColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let inputType = getInputTypeForTextField(textField) else { return }
        
        delegate?.didEndEditingFor(inputType: inputType, currentText: textField.text) { text, textColor in
            textField.text = text
            textField.textColor = textColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
    
    private func getInputTypeForTextField(_ textField: UITextField) -> EventSetupInputType? {
        if textField == firstNameTextField {
            return .firstName
        } else if textField == lastNameTextField {
            return .lastName
        } else if textField == addressOneTextField {
            return .addressOne
        } else if textField == addressTwoTextField {
            return .addressTwo
        } else {
            return nil
        }
    }
}
