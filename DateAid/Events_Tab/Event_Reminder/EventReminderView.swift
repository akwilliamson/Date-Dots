//
//  EventReminderVIew.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/3/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventReminderViewDelegate {
    func didSelectDaysBefore(_ daysBefore: Int)
    func didSelectTimeOfDay(date: Foundation.Date)
    func didTapCancelReminder()
}

class EventReminderView: BaseView {
    
    // MARK: Content
    
    struct Content {
        let selectedDaysBeforeIndex: Int
        let selectedTimeOfDayDate: Foundation.Date
        let descriptionLabelText: String
        let shouldShowCancelButton: Bool
    }
    
    // MARK: UI
    
    private let containerStackView: UIStackView
    private let descriptionLabel: UILabel
    private let daysBeforeLabel: UILabel
    private let daysBeforeContainerStackView: UIStackView
    private let daysBeforeFirstRowStackView: UIStackView
    private let zeroDaysBeforeLabel: ReminderCircleLabel
    private let oneDayBeforeLabel: ReminderCircleLabel
    private let twoDaysBeforeLabel: ReminderCircleLabel
    private let threeDaysBeforeLabel: ReminderCircleLabel
    private let daysBeforeSecondRowStackView: UIStackView
    private let fourDaysBeforeLabel: ReminderCircleLabel
    private let fiveDaysBeforeLabel: ReminderCircleLabel
    private let sixDaysBeforeLabel: ReminderCircleLabel
    private let sevenDaysBeforeLabel: ReminderCircleLabel
    private let timeOfDayLabel: UILabel
    private let timeOfDayPickerView: UIDatePicker
    private let cancelReminderButton: UIButton
    
    // MARK: Properties
    
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
        
        daysBeforeLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = FontType.avenirNextDemiBold(20).font
            label.text = "Days Before"
            return label
        }()
        
        daysBeforeContainerStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 20
            stackView.axis = .vertical
            return stackView
        }()
        
        daysBeforeFirstRowStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            return stackView
        }()
        
        zeroDaysBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            return label
        }()
        
        oneDayBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .one)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            return label
        }()
        
        twoDaysBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .two)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            return label
        }()
        
        threeDaysBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .three)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            return label
        }()
        
        daysBeforeSecondRowStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            return stackView
        }()
        
        fourDaysBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .four)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            return label
        }()
        
        fiveDaysBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .five)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            return label
        }()
        
        sixDaysBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .six)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            return label
        }()
        
        sevenDaysBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .seven)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            return label
        }()
        
        timeOfDayLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = FontType.avenirNextDemiBold(20).font
            label.text = "Time of Day"
            return label
        }()
        
        timeOfDayPickerView = {
            let datePicker = UIDatePicker()
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            datePicker.datePickerMode = .time
            datePicker.timeZone = .current
            if #available(iOS 14, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
            datePicker.minuteInterval = 15
            return datePicker
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
        timeOfDayPickerView.addTarget(self, action: #selector(didSelectTimeOfDay), for: .valueChanged)
        cancelReminderButton.addTarget(self, action: #selector(didCancelReminder), for: .touchUpInside)
        
        let zeroTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel))
        let oneTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel))
        let twoTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel))
        let threeTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel))
        let fourTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel))
        let fiveTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel))
        let sixTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel))
        let sevenTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel))
        
        zeroDaysBeforeLabel.addGestureRecognizer(zeroTapGesture)
        oneDayBeforeLabel.addGestureRecognizer(oneTapGesture)
        twoDaysBeforeLabel.addGestureRecognizer(twoTapGesture)
        threeDaysBeforeLabel.addGestureRecognizer(threeTapGesture)
        fourDaysBeforeLabel.addGestureRecognizer(fourTapGesture)
        fiveDaysBeforeLabel.addGestureRecognizer(fiveTapGesture)
        sixDaysBeforeLabel.addGestureRecognizer(sixTapGesture)
        sevenDaysBeforeLabel.addGestureRecognizer(sevenTapGesture)
    }
    
    override func constructSubviewHierarchy() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(descriptionLabel)
        containerStackView.addArrangedSubview(daysBeforeLabel)
        containerStackView.setCustomSpacing(20, after: daysBeforeLabel)
        containerStackView.addArrangedSubview(daysBeforeContainerStackView)
        daysBeforeContainerStackView.addArrangedSubview(daysBeforeFirstRowStackView)
        daysBeforeFirstRowStackView.addArrangedSubview(zeroDaysBeforeLabel)
        daysBeforeFirstRowStackView.addArrangedSubview(oneDayBeforeLabel)
        daysBeforeFirstRowStackView.addArrangedSubview(twoDaysBeforeLabel)
        daysBeforeFirstRowStackView.addArrangedSubview(threeDaysBeforeLabel)
        daysBeforeContainerStackView.addArrangedSubview(daysBeforeSecondRowStackView)
        daysBeforeSecondRowStackView.addArrangedSubview(fourDaysBeforeLabel)
        daysBeforeSecondRowStackView.addArrangedSubview(fiveDaysBeforeLabel)
        daysBeforeSecondRowStackView.addArrangedSubview(sixDaysBeforeLabel)
        daysBeforeSecondRowStackView.addArrangedSubview(sevenDaysBeforeLabel)
        containerStackView.setCustomSpacing(20, after: daysBeforeContainerStackView)
        containerStackView.addArrangedSubview(timeOfDayLabel)
        containerStackView.setCustomSpacing(20, after: timeOfDayLabel)
        containerStackView.addArrangedSubview(timeOfDayPickerView)
        containerStackView.addArrangedSubview(cancelReminderButton)
    }
    
    override func constructLayout() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            descriptionLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/8)
        ])
        
        NSLayoutConstraint.activate([
            daysBeforeContainerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            daysBeforeContainerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            zeroDaysBeforeLabel.heightAnchor.constraint(equalTo: zeroDaysBeforeLabel.widthAnchor),
            fourDaysBeforeLabel.heightAnchor.constraint(equalTo: zeroDaysBeforeLabel.widthAnchor)
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
    
    @objc
    func didSelectDaysBeforeLabel(_ sender: UITapGestureRecognizer) {
        guard let daysBeforeLabel = sender.view as? ReminderCircleLabel else { return }
        delegate?.didSelectDaysBefore(daysBeforeLabel.daysBefore.rawValue)
    }
}

// MARK: - Populatable

extension EventReminderView: Populatable {

    func populate(with content: Content) {
        self.descriptionLabel.text = content.descriptionLabelText
        self.timeOfDayPickerView.date = content.selectedTimeOfDayDate
        self.cancelReminderButton.isHidden = !content.shouldShowCancelButton
    }

    func updateDescriptionLabel(text: String) {
        descriptionLabel.text = text
    }
}
