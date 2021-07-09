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
            static let daysBefore = "Days Before Event"
            static let timeOfDay = "At Time"
        }
    }
    
    // MARK: UI
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let scheduleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontType.noteworthyBold(30).font
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let dayPriorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = FontType.avenirNextBold(20).font
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
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    private let zeroDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: 0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 0
        return label
    }()
    
    private let oneDayPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 1
        return label
    }()
    
    private let twoDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 2
        return label
    }()
    
    private let threeDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: 3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 3
        return label
    }()
    
    private let daysPriorSecondRowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    private let fourDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: 4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 4
        return label
    }()
    
    private let fiveDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: 5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 5
        return label
    }()
    
    private let sixDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: 6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 6
        return label
    }()
    
    private let sevenDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(dayPrior: 7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 7
        return label
    }()
    
    private let timeOfDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = FontType.avenirNextBold(20).font
        label.text = Constant.String.timeOfDay
        return label
    }()
    
    private lazy var fireTimePickerView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(didSelectTimeOfDay), for: .valueChanged)
        datePicker.datePickerMode = .time
        datePicker.timeZone = .current
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.minuteInterval = 15
        return datePicker
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didPressDelete), for: .touchUpInside)
        button.setBackgroundImage(UIImage(systemName: "trash.circle"), for: .normal)
        button.tintColor = UIColor.compatibleLabel
        
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
        
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(scheduleLabel)
        containerStackView.setCustomSpacing(30, after: scheduleLabel)
        containerStackView.addArrangedSubview(dayPriorLabel)
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
        containerStackView.setCustomSpacing(10, after: sevenDaysPriorLabel)
        containerStackView.addArrangedSubview(timeOfDayLabel)
        containerStackView.addArrangedSubview(fireTimePickerView)
        addSubview(deleteButton)
    }
    
    override func constructLayout() {
        super.constructLayout()
        
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            scheduleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            zeroDaysPriorLabel.heightAnchor.constraint(equalTo: zeroDaysPriorLabel.widthAnchor),
            fourDaysPriorLabel.heightAnchor.constraint(equalTo: fourDaysPriorLabel.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: containerStackView.bottomAnchor),
            deleteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 60),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor)
        ])
    }
    
    // MARK: Public Methods
    
    func updateScheduleLabel(text: String) {
        scheduleLabel.text = text
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

        selectedDayPriorLabel = dayPriorLabel
        selectedDayPriorLabel?.spring()
        
        delegate?.didSelectDayPrior(dayPriorLabel.dayPrior)
    }
}

// MARK: - Populatable

extension ReminderView: Populatable {
    
    // MARK: Content
    
    struct Content {
        let scheduleText: String
        let eventColor: UIColor
        let eventDaysFromNow: Int
        let eventDaysFromFireDate: Int
        let fireDate: Date
        let isScheduled: Bool
    }

    func populate(with content: Content) {
        scheduleLabel.text = content.scheduleText
        
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
            
            if label.tag >= content.eventDaysFromNow {
                label.isUserInteractionEnabled = false
                label.alpha = 0.3
            }
        }

        selectedDayPriorLabel = daysPriorLabels[safe: content.eventDaysFromFireDate]
        
        fireTimePickerView.date = content.fireDate
        
        if content.isScheduled {
            deleteButton.isHidden = false
        } else {
            selectedDayPriorLabel = zeroDaysPriorLabel
            deleteButton.isHidden = true
        }
    }
}
