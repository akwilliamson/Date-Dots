//
//  EventReminderVIew.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/3/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventReminderViewDelegate {
    func didSelectDaysBefore(at row: Int)
    func didSelectTimeOfDay(date: Foundation.Date)
    func didTapCancelReminder()
}

class EventReminderView: BaseView {
    
    // MARK: Content
    
    struct Content {
        let daysBeforePickerOptions: [String]
        let selectedDaysBeforeIndex: Int
        let selectedTimeOfDayDate: Foundation.Date
        let descriptionLabelText: String
        let shouldShowCancelButton: Bool
    }
    
    // MARK: UI
    
    private let containerStackView: UIStackView
    private let descriptionLabel: UILabel
    private let pickerStackView: UIStackView
    private let daysBeforePickerView: UIPickerView
    private let timeOfDayPickerView: UIDatePicker
    private let cancelReminderButton: UIButton
    
    // MARK: Properties
    
    private var pickerViewNumberOfComponents: Int = 0
    private var pickerViewOptions: [String] = []
    
    var delegate: EventReminderViewDelegate?
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        containerStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            return stackView
        }()

        descriptionLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = FontType.avenirNextBold(25).font
            label.textAlignment = .center
            return label
        }()
        
        pickerStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            return stackView
        }()
        
        daysBeforePickerView = {
            let pickerView = UIPickerView()
            pickerView.translatesAutoresizingMaskIntoConstraints = false
            return pickerView
        }()
        
        timeOfDayPickerView = {
            let pickerView = UIDatePicker()
            pickerView.translatesAutoresizingMaskIntoConstraints = false
            pickerView.datePickerMode = .time
            pickerView.minuteInterval = 15
            return pickerView
        }()
        
        cancelReminderButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .red
            button.setTitle("Cancel Reminder", for: .normal)
            button.setTitleColor(.white, for: .normal)
            return button
        }()
        
        super.init(frame: frame)

        configureView()
    }
    
    // MARK: Lifecycle
    
    private func configureView() {
        backgroundColor = .compatibleSystemBackground
        daysBeforePickerView.delegate = self
        daysBeforePickerView.dataSource = self
        timeOfDayPickerView.addTarget(self, action: #selector(didSelectTimeOfDay), for: .valueChanged)
        cancelReminderButton.addTarget(self, action: #selector(didCancelReminder), for: .touchUpInside)
    }
    
    override func constructSubviewHierarchy() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(descriptionLabel)
        containerStackView.addArrangedSubview(pickerStackView)
        pickerStackView.addArrangedSubview(daysBeforePickerView)
        pickerStackView.addArrangedSubview(timeOfDayPickerView)
        containerStackView.setCustomSpacing(20, after: pickerStackView)
        containerStackView.addArrangedSubview(cancelReminderButton)
    }
    
    override func constructLayout() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            descriptionLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/4)
        ])
        
        NSLayoutConstraint.activate([
            daysBeforePickerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/4)
        ])
        
        NSLayoutConstraint.activate([
            timeOfDayPickerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/4)
        ])
        
        NSLayoutConstraint.activate([
            cancelReminderButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/3),
            cancelReminderButton.heightAnchor.constraint(equalToConstant: 50),
            cancelReminderButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cancelReminderButton.trailingAnchor.constraint(equalTo: leadingAnchor, constant: -20)
        ])
    }
    
    // MARK: Actions
    
    @objc
    func didSelectTimeOfDay(_ sender: UIDatePicker) {
        delegate?.didSelectTimeOfDay(date: sender.date)
    }
    
    @objc
    func didCancelReminder(_ sender: UIButton) {
        delegate?.didTapCancelReminder()
    }
}

// MARK: - Populatable

extension EventReminderView: Populatable {

    func populate(with content: Content) {
        self.pickerViewOptions = content.daysBeforePickerOptions
        self.descriptionLabel.text = content.descriptionLabelText
        self.daysBeforePickerView.selectRow(content.selectedDaysBeforeIndex, inComponent: 0, animated: false)
        self.timeOfDayPickerView.date = content.selectedTimeOfDayDate
        self.cancelReminderButton.isHidden = !content.shouldShowCancelButton
    }

    func updateDescriptionLabel(text: String) {
        descriptionLabel.text = text
    }
}

// MARK: - UIPickerViewDataSource

extension EventReminderView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewOptions.count
    }
}

// MARK: - UIPickerViewDelegate

extension EventReminderView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectDaysBefore(at: row)
    }
}
