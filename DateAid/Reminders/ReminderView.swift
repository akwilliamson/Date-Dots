//
//  ReminderView.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/3/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

protocol ReminderViewDelegate {
    
    func didSelectDayPrior(_ dayPrior: Int)
    func didChangeTimeOfDay(date: Date)
    func didPressDelete()
}

class ReminderView: BaseView {
    
    // MARK: Constant
    
    private enum Constant {
        enum String {
            static let daysBefore = "Days Before"
            static let timeOfDay = "Time of Day"
            static let cancelReminder = "Cancel Reminder"
        }
    }
    
    // MARK: UI
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private let scheduledLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontType.avenirNextBold(25).font
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let dayPriorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = FontType.noteworthyBold(20).font
        label.text = Constant.String.daysBefore
        return label
    }()
    
    private let daysPriorContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .vertical
        return stackView
    }()
    
    private let daysPriorFirstRowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let zeroDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 0
        return label
    }()
    
    private let oneDayPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: .one)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 1
        return label
    }()
    
    private let twoDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: .two)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 2
        return label
    }()
    
    private let threeDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: .three)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 3
        return label
    }()
    
    private let daysPriorSecondRowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let fourDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: .four)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 4
        return label
    }()
    
    private let fiveDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: .five)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 5
        return label
    }()
    
    private let sixDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: .six)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 6
        return label
    }()
    
    private let sevenDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: .seven)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 7
        return label
    }()
    
    private let timeOfDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = FontType.noteworthyBold(20).font
        label.text = Constant.String.timeOfDay
        return label
    }()
    
    private let timeOfDayPickerView: UIDatePicker = {
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
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle(Constant.String.cancelReminder, for: .normal)
        button.titleLabel?.font = FontType.avenirNextDemiBold(20).font
        button.setTitleColor(UIColor.compatibleLabel, for: .normal)
        button.isHidden = true
        
        return button
    }()
    
    // MARK: Public Properties
    
    var delegate: ReminderViewDelegate?
    
    // MARK: Private Properties
    
    private var selectedDayPriorLabel: UIView? {
        willSet {
            selectedDayPriorLabel?.layer.borderWidth = 0
            selectedDayPriorLabel?.layer.borderColor = nil
        }
        didSet {
            selectedDayPriorLabel?.layer.borderWidth = 5
            selectedDayPriorLabel?.layer.borderColor = UIColor.compatibleLabel.cgColor
        }
    }
    
    // MARK: Lifecycle
    
    override func configureView() {
        super.configureView()
        backgroundColor = .compatibleSystemBackground

        timeOfDayPickerView.addTarget(self, action: #selector(didSelectTimeOfDay), for: .valueChanged)
        deleteButton.addTarget(self, action: #selector(didPressDelete), for: .touchUpInside)

        zeroDaysPriorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDayPrior)))
        oneDayPriorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDayPrior)))
        twoDaysPriorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDayPrior)))
        threeDaysPriorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDayPrior)))
        fourDaysPriorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDayPrior)))
        fiveDaysPriorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDayPrior)))
        sixDaysPriorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDayPrior)))
        sevenDaysPriorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDayPrior)))
    }
    
    override func constructSubviewHierarchy() {
        super.constructSubviewHierarchy()
        
        let customSpacing: CGFloat
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            customSpacing = 20
        default:
            customSpacing = 30
        }
        
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(scheduledLabel)
        containerStackView.setCustomSpacing(customSpacing, after: scheduledLabel)
        containerStackView.addArrangedSubview(deleteButton)
        containerStackView.setCustomSpacing(customSpacing, after: deleteButton)
        containerStackView.addArrangedSubview(dayPriorLabel)
        containerStackView.setCustomSpacing(20, after: dayPriorLabel)
        containerStackView.addArrangedSubview(daysPriorContainerStackView)
        daysPriorContainerStackView.addArrangedSubview(daysPriorFirstRowStackView)
        daysPriorFirstRowStackView.addArrangedSubview(zeroDaysPriorLabel)
        daysPriorFirstRowStackView.addArrangedSubview(oneDayPriorLabel)
        daysPriorFirstRowStackView.addArrangedSubview(twoDaysPriorLabel)
        daysPriorFirstRowStackView.addArrangedSubview(threeDaysPriorLabel)
        daysPriorContainerStackView.addArrangedSubview(daysPriorSecondRowStackView)
        daysPriorSecondRowStackView.addArrangedSubview(fourDaysPriorLabel)
        daysPriorSecondRowStackView.addArrangedSubview(fiveDaysPriorLabel)
        daysPriorSecondRowStackView.addArrangedSubview(sixDaysPriorLabel)
        daysPriorSecondRowStackView.addArrangedSubview(sevenDaysPriorLabel)
        containerStackView.setCustomSpacing(customSpacing, after: daysPriorContainerStackView)
        containerStackView.addArrangedSubview(timeOfDayLabel)
        containerStackView.addArrangedSubview(timeOfDayPickerView)
    }
    
    override func constructLayout() {
        super.constructLayout()
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            NSLayoutConstraint.activate([
                scheduledLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
                scheduledLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        default:
            NSLayoutConstraint.activate([
                scheduledLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
                scheduledLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
        
        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: leadingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            dayPriorLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            daysPriorContainerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            daysPriorContainerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            zeroDaysPriorLabel.heightAnchor.constraint(equalTo: zeroDaysPriorLabel.widthAnchor),
            fourDaysPriorLabel.heightAnchor.constraint(equalTo: zeroDaysPriorLabel.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeOfDayLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: Actions
    
    @objc
    func didSelectTimeOfDay(_ sender: UIDatePicker) {
        delegate?.didChangeTimeOfDay(date: sender.date)
    }
    
    @objc
    func didPressDelete(_ sender: UIButton) {
        delegate?.didPressDelete()
    }
    
    @objc
    func didSelectDayPrior(_ sender: UITapGestureRecognizer) {
        guard let dayPriorLabel = sender.view as? ReminderCircleLabel else { return }
        delegate?.didSelectDayPrior(dayPriorLabel.dayPrior.rawValue)

        selectedDayPriorLabel = dayPriorLabel
        selectedDayPriorLabel?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6,
            options: .allowUserInteraction)
        {
            self.selectedDayPriorLabel?.transform = .identity
        } completion: { _ in }
    }
}

// MARK: - Populatable

extension ReminderView: Populatable {
    
    // MARK: Content
    
    struct Content {
        let eventColor: UIColor
        let daysUntilEvent: Int
        let dayPrior: ReminderDayPrior
        let timeOfDay: Date
        let isScheduled: Bool
        let scheduledText: String
    }

    func populate(with content: Content) {
        self.scheduledLabel.text = content.scheduledText
        self.timeOfDayPickerView.date = content.timeOfDay
        
        let daysPriorLabels = [
            zeroDaysPriorLabel,
            oneDayPriorLabel,
            twoDaysPriorLabel,
            threeDaysPriorLabel,
            fourDaysPriorLabel,
            fiveDaysPriorLabel,
            sixDaysPriorLabel,
            sevenDaysPriorLabel
        ]
        
        daysPriorLabels.forEach { label in
            label.backgroundColor = content.eventColor
            if label.tag >= content.daysUntilEvent {
                label.alpha = 0.3
                label.isUserInteractionEnabled = false
            }
        }
        
        if content.isScheduled {
            selectedDayPriorLabel = daysPriorLabels[content.dayPrior.rawValue]
            deleteButton.isHidden = false
        }
    }

    func updateScheduledLabel(text: String) {
        scheduledLabel.text = text
    }
}
