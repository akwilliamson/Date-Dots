//
//  ReminderView.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/3/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

protocol ReminderViewDelegate: AnyObject {
    
    func didSelectWeeksPrior(_ weekPrior: Int)
    func didSelectDaysPrior(_ dayPrior: Int)
    func didChangeTimeOfDay(date: Date)
}

class ReminderView: BaseView {
    
    // MARK: Constant
    
    private enum Constant {
        enum String {
            static let weeksBefore = "Weeks Before Event"
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
    
    private let weeksPriorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = FontType.avenirNextBold(20).font
        label.text = Constant.String.weeksBefore
        return label
    }()
    
    private let weeksPriorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    private let oneWeekPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 1
        return label
    }()
    
    private let twoWeeksPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 2
        return label
    }()
    
    private let threeWeeksPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 3
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
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let zeroDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 0
        
        return label
    }()
    
    private let oneDayPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 1
        return label
    }()
    
    private let twoDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 2
        return label
    }()
    
    private let threeDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 3
        return label
    }()
    
    private let daysPriorSecondRowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let fourDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 4
        return label
    }()
    
    private let fiveDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 5
        return label
    }()
    
    private let sixDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 6
        return label
    }()
    
    private let sevenDaysPriorLabel: ReminderCircleLabel = {
        let label = ReminderCircleLabel(7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.tag = 7
        return label
    }()
    
    private let timePickerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
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
    
    // MARK: Public Properties
    
    weak var delegate: ReminderViewDelegate?
    
    // MARK: Private Properties
    
    private var selectedWeeksPriorLabel: UIView? {
        willSet {
            selectedWeeksPriorLabel?.layer.borderWidth = 0
            selectedWeeksPriorLabel?.layer.borderColor = nil
            selectedDayPriorLabel?.layer.borderWidth = 0
            selectedDayPriorLabel?.layer.borderColor = nil
        }
        didSet {
            selectedWeeksPriorLabel?.layer.borderWidth = 5
            selectedWeeksPriorLabel?.layer.borderColor = UIColor.compatibleLabel.cgColor
        }
    }
    
    private var selectedDayPriorLabel: UIView? {
        willSet {
            selectedWeeksPriorLabel?.layer.borderWidth = 0
            selectedWeeksPriorLabel?.layer.borderColor = nil
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

        oneWeekPriorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectWeeksPrior)))
        twoWeeksPriorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectWeeksPrior)))
        threeWeeksPriorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectWeeksPrior)))
        
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
        containerStackView.setCustomSpacing(20, after: scheduleLabel)
        
        containerStackView.addArrangedSubview(weeksPriorLabel)
        containerStackView.addArrangedSubview(weeksPriorStackView)
        weeksPriorStackView.addArrangedSubview(oneWeekPriorLabel)
        weeksPriorStackView.addArrangedSubview(twoWeeksPriorLabel)
        weeksPriorStackView.addArrangedSubview(threeWeeksPriorLabel)
        
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
        
        containerStackView.addArrangedSubview(timePickerStackView)
        timePickerStackView.addArrangedSubview(timeOfDayLabel)
        timePickerStackView.addArrangedSubview(fireTimePickerView)
    }
    
    override func constructLayout() {
        super.constructLayout()
        
        NSLayoutConstraint.activate([
            scheduleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            oneWeekPriorLabel.heightAnchor.constraint(equalTo: oneWeekPriorLabel.widthAnchor),
            oneWeekPriorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            threeWeeksPriorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            zeroDaysPriorLabel.heightAnchor.constraint(equalTo: zeroDaysPriorLabel.widthAnchor),
            fourDaysPriorLabel.heightAnchor.constraint(equalTo: fourDaysPriorLabel.widthAnchor),
            
            zeroDaysPriorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            fourDaysPriorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            threeDaysPriorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            sevenDaysPriorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: Public Methods
    
    func updateScheduleLabel(text: String) {
        scheduleLabel.text = text
    }
    
    // MARK: Actions
    
    @objc
    func didSelectDayPrior(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? ReminderCircleLabel else { return }

        selectedDayPriorLabel = label
        selectedDayPriorLabel?.spring()
        
        delegate?.didSelectDaysPrior(label.number)
    }
    
    @objc
    func didSelectWeeksPrior(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? ReminderCircleLabel else { return }

        selectedWeeksPriorLabel = label
        selectedWeeksPriorLabel?.spring()
        
        delegate?.didSelectWeeksPrior(label.number)
    }
    
    @objc
    func didSelectTimeOfDay(_ sender: UIDatePicker) {
        delegate?.didChangeTimeOfDay(date: sender.date)
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
        
        let weeksPriorLabels = [
            oneWeekPriorLabel,
            twoWeeksPriorLabel,
            threeWeeksPriorLabel
        ]
        
        weeksPriorLabels.forEach { label in
            label.backgroundColor = content.eventColor
            
            if label.tag >= content.eventDaysFromNow {
                label.isUserInteractionEnabled = false
                label.alpha = 0.3
            }
        }
        
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
        
        if !content.isScheduled {
            selectedDayPriorLabel = zeroDaysPriorLabel
        }
    }
}
