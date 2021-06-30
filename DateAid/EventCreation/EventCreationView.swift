//
//  EventCreationView.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/25/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventCreationViewDelegate: AnyObject {
    
    func didSelectEventType(eventType: EventType)
    func didChangeFirstName(text: String?)
    func didChangeLastName(text: String?)
    func didChangeAddress(text: String?)
    func didChangeRegion(text: String?)
    func didToggleYearPicker(isOn: Bool)
    func didSelectPicker(row: Int, in component: Int)
}

class EventCreationView: BaseView {
    
    // MARK: Constants
    
    private enum Constant {
        enum String {
            static let hideYear = "Hide Year"
            static let showYear = "Show Year"
            static let firstName = "First Name"
            static let firstNames = "First Name(s)"
            static let lastName = "Last Name"
            static let address = "Address"
            static let region = "City, State, ZIP"
        }
    }
    
    // MARK: UI
    
    private var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        return stackView
    }()
    
    // Dots
    
    private let eventDotStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var birthdayDot: EventCircleImageView = {
        let dotView = EventCircleImageView(eventType: .birthday)
        dotView.setSelectedState(isSelected: false)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventTypePressed))
        dotView.addGestureRecognizer(tapGesture)
        
        return dotView
    }()

    private lazy var anniversaryDot: EventCircleImageView = {
        let dotView = EventCircleImageView(eventType: .anniversary)
        dotView.setSelectedState(isSelected: false)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventTypePressed))
        dotView.addGestureRecognizer(tapGesture)
        
        return dotView
    }()

    private lazy var customDot: EventCircleImageView = {
        let dotView = EventCircleImageView(eventType: .custom)
        dotView.setSelectedState(isSelected: false)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventTypePressed))
        dotView.addGestureRecognizer(tapGesture)
        
        return dotView
    }()

    private lazy var otherDot: EventCircleImageView = {
        let dotView = EventCircleImageView(eventType: .other)
        dotView.setSelectedState(isSelected: false)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventTypePressed))
        dotView.addGestureRecognizer(tapGesture)
        
        return dotView
    }()
    
    // Input Fields
    
    private let inputBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    private var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var nameInputField: PaddedTextField = {
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
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.compatiblePlaceholderText,
            NSAttributedString.Key.font: FontType.avenirNextDemiBold(23).font
        ]
        textField.attributedPlaceholder = NSAttributedString(string: Constant.String.firstName, attributes: attributes)
        textField.addTarget(self, action: #selector(firstNameDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var lastNameInputField: PaddedTextField = {
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
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.compatiblePlaceholderText,
            NSAttributedString.Key.font: FontType.avenirNextDemiBold(23).font
        ]
        textField.attributedPlaceholder = NSAttributedString(string: Constant.String.lastName, attributes: attributes)
        textField.addTarget(self, action: #selector(lastNameDidChange), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var addressInputField: PaddedTextField = {
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
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.compatiblePlaceholderText,
            NSAttributedString.Key.font: FontType.avenirNextDemiBold(23).font
        ]
        textField.attributedPlaceholder = NSAttributedString(string: Constant.String.address, attributes: attributes)
        textField.addTarget(self, action: #selector(addressDidChange), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var regionInputField: PaddedTextField = {
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
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.compatiblePlaceholderText,
            NSAttributedString.Key.font: FontType.avenirNextDemiBold(23).font
        ]
        textField.attributedPlaceholder = NSAttributedString(string: Constant.String.region, attributes: attributes)
        textField.addTarget(self, action: #selector(regionDidChange), for: .editingChanged)
        
        return textField
    }()
    
    // Picker
    
    private let toggleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let hideYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constant.String.hideYear
        label.font = FontType.avenirNextMedium(15).font
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var yearToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(toggleDidChange), for: .valueChanged)
        toggle.isOn = true
        
        return toggle
    }()
    
    private let showYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constant.String.showYear
        label.font = FontType.avenirNextMedium(15).font
        label.textAlignment = .left
        label.alpha = 0

        return label
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self
        
        return pickerView
    }()
    
    // MARK: Properties
    
    weak var delegate: EventCreationViewDelegate?
    
    private var selectedEventType: EventType = .birthday
    
    private var showYear = true {
        didSet {
            showYearLabel.alpha =  showYear ? 0 : 1
            hideYearLabel.alpha = !showYear ? 0 : 1
        }
    }
    
    private var days: [String] = []
    private var months: [String] = []
    private var years: [String] = []
    
    // MARK: View Setup
    
    override func configureView() {
        super.configureView()
        backgroundColor = .compatibleSystemBackground
    }
    
    override func constructSubviewHierarchy() {
        super.constructSubviewHierarchy()
        addSubview(containerView)
            containerView.addArrangedSubview(eventDotStackView)
                eventDotStackView.addArrangedSubview(birthdayDot)
                eventDotStackView.addArrangedSubview(anniversaryDot)
                eventDotStackView.addArrangedSubview(customDot)
                eventDotStackView.addArrangedSubview(otherDot)
            containerView.addArrangedSubview(inputBackgroundView)
                inputBackgroundView.addSubview(inputStackView)
                    inputStackView.addArrangedSubview(nameInputField)
                    inputStackView.addArrangedSubview(lastNameInputField)
                    inputStackView.setCustomSpacing(30, after: lastNameInputField)
                    inputStackView.addArrangedSubview(addressInputField)
                    inputStackView.addArrangedSubview(regionInputField)
            containerView.addArrangedSubview(toggleStackView)
                toggleStackView.addArrangedSubview(hideYearLabel)
                toggleStackView.addArrangedSubview(yearToggle)
                toggleStackView.addArrangedSubview(showYearLabel)
            containerView.addArrangedSubview(pickerView)
    }
    
    override func constructLayout() {
        super.constructLayout()
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            eventDotStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            eventDotStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            eventDotStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            birthdayDot.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/6),
            birthdayDot.heightAnchor.constraint(equalTo: birthdayDot.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            inputStackView.topAnchor.constraint(equalTo: inputBackgroundView.topAnchor),
            inputStackView.bottomAnchor.constraint(equalTo: inputBackgroundView.bottomAnchor),
            inputStackView.leadingAnchor.constraint(equalTo: inputBackgroundView.leadingAnchor),
            inputStackView.trailingAnchor.constraint(equalTo: inputBackgroundView.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            nameInputField.topAnchor.constraint(equalTo: inputBackgroundView.topAnchor, constant: 15),
            nameInputField.heightAnchor.constraint(equalToConstant: 45),
            nameInputField.leadingAnchor.constraint(equalTo: inputBackgroundView.leadingAnchor, constant: 20),
            nameInputField.trailingAnchor.constraint(equalTo: inputBackgroundView.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            lastNameInputField.heightAnchor.constraint(equalToConstant: 45),
        ])
        NSLayoutConstraint.activate([
            regionInputField.bottomAnchor.constraint(equalTo: inputBackgroundView.bottomAnchor, constant: -15)
        ])
        NSLayoutConstraint.activate([
            yearToggle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            pickerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: Interface
    
    func selectEventType(_ eventType: EventType) {
        // Deselect the currently selected event type
        switch self.selectedEventType {
        case .birthday:
            birthdayDot.setSelectedState(isSelected: false)
        case .anniversary:
            anniversaryDot.setSelectedState(isSelected: false)
        case .custom:
            customDot.setSelectedState(isSelected: false)
        case .other:
            otherDot.setSelectedState(isSelected: false)
        }
        
        self.selectedEventType = eventType
        
        // Select the newly selected event type
        switch selectedEventType {
        case .birthday:
            birthdayDot.setSelectedState(isSelected: true)
        case .anniversary:
            anniversaryDot.setSelectedState(isSelected: true)
        case .custom:
            customDot.setSelectedState(isSelected: true)
        case .other:
            otherDot.setSelectedState(isSelected: true)
        }
        
        inputBackgroundView.backgroundColor = selectedEventType.color
        yearToggle.onTintColor = selectedEventType.color
    }
    
    func populateDays(days: [String]) {
        self.days = days
    }
    
    func selectMonth(row: Int) {
        pickerView.selectRow(row, inComponent: 0, animated: false)
        pickerView(pickerView, didSelectRow: row, inComponent: 0)
    }
    
    func selectDay(row: Int) {
        pickerView.selectRow(row, inComponent: 1, animated: false)
        pickerView(pickerView, didSelectRow: row, inComponent: 1)
    }
    
    func selectYear(row: Int) {
        pickerView.selectRow(row, inComponent: 2, animated: false)
        pickerView(pickerView, didSelectRow: row, inComponent: 2)
    }
    
    func reloadAllComponents() {
        pickerView.reloadAllComponents()
    }
    
    // MARK: Actions
    
    @objc
    func eventTypePressed(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? EventCircleImageView else { return }
        delegate?.didSelectEventType(eventType: view.eventType)
    }
    
    @objc
    func toggleDidChange(sender: UISwitch) {
        showYear = sender.isOn
        pickerView.reloadAllComponents()
        delegate?.didToggleYearPicker(isOn: sender.isOn)
    }
    
    @objc
    func firstNameDidChange(sender: UITextField) {
        delegate?.didChangeFirstName(text: sender.text)
    }
    
    @objc
    func lastNameDidChange(sender: UITextField) {
        delegate?.didChangeLastName(text: sender.text)
    }
    
    @objc
    func addressDidChange(sender: UITextField) {
        delegate?.didChangeAddress(text: sender.text)
    }
    
    @objc
    func regionDidChange(sender: UITextField) {
        delegate?.didChangeRegion(text: sender.text)
    }
}

// MARK: - UITextFieldDelegate

extension EventCreationView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField {
        case nameInputField:
            lastNameInputField.becomeFirstResponder()
        case lastNameInputField:
            textField.resignFirstResponder()
        case addressInputField:
            regionInputField.becomeFirstResponder()
        case regionInputField:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}

// MARK: - UIPickerViewDataSource

extension EventCreationView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return showYear ? 3 : 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return months.count
        case 1: return days.count
        case 2: return years.count
        default:
            return 0
        }
    }
}

// MARK: - UIPickerViewDelegate

extension EventCreationView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return months[row]
        case 1: return days[row]
        case 2: return years[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectPicker(row: row, in: component)
    }
}

extension EventCreationView: Populatable {
    
    struct Content {
        let eventType: EventType
        let firstName: String
        let lastName: String
        let street: String
        let region: String
        let selectedDay: Int
        let selectedMonth: Int
        let selectedYear: Int
        let days: [String]
        let months: [String]
        let years: [String]
    }
    
    func populate(with content: Content) {
        selectEventType(content.eventType)
        
        if !content.firstName.isEmpty {
            nameInputField.text = content.firstName
        }
        if !content.lastName.isEmpty {
            lastNameInputField.text = content.lastName
        }
        if !content.street.isEmpty {
            addressInputField.text = content.street
        }
        if !content.region.isEmpty {
            regionInputField.text = content.region
        }
        
        self.days = content.days
        self.months = content.months
        self.years = content.years
        
        reloadAllComponents()
        
        selectDay(row: content.selectedDay-1)
        selectMonth(row: content.selectedMonth-1)
        selectYear(row: content.selectedYear)
    }
}
