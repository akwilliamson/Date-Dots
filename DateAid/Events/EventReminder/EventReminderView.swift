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
    func didSelectTimeOfDay(date: Date)
    func didTapCancelReminder()
}

class EventReminderView: BaseView {
    
    // MARK: Content
    
    struct Content {
        let selectedDaysBeforeIndex: Int
        let selectedTimeOfDayDate: Date
        let descriptionLabelText: String
        let notificationFound: Bool
        let daysUntilEvent: Int
    }
    
    // MARK: Constant
    
    private enum Constant {
        enum String {
            static let daysBefore = "Days Before"
            static let timeOfDay = "Time of Day"
            static let cancelReminder = "Cancel Reminder"
        }
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
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        
        daysBeforeLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = FontType.noteworthyBold(20).font
            label.text = Constant.String.daysBefore
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
            label.tag = 0
            return label
        }()
        
        oneDayBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .one)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            label.tag = 1
            return label
        }()
        
        twoDaysBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .two)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            label.tag = 2
            return label
        }()
        
        threeDaysBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .three)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            label.tag = 3
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
            label.tag = 4
            return label
        }()
        
        fiveDaysBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .five)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            label.tag = 5
            return label
        }()
        
        sixDaysBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .six)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            label.tag = 6
            return label
        }()
        
        sevenDaysBeforeLabel = {
            let label = ReminderCircleLabel(daysBefore: .seven)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isUserInteractionEnabled = true
            label.tag = 7
            return label
        }()
        
        timeOfDayLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = FontType.noteworthyBold(20).font
            label.text = Constant.String.timeOfDay
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
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.setTitle(Constant.String.cancelReminder, for: .normal)
            button.titleLabel?.font = FontType.avenirNextDemiBold(20).font
            button.setTitleColor(UIColor.compatibleLabel, for: .normal)
            return button
        }()
        
        super.init(frame: frame)

        configureView()
    }
    
    // MARK: Lifecycle
    
    override func configureView() {
        super.configureView()
        backgroundColor = .compatibleSystemBackground

        timeOfDayPickerView.addTarget(self, action: #selector(didSelectTimeOfDay), for: .valueChanged)
        cancelReminderButton.addTarget(self, action: #selector(didCancelReminder), for: .touchUpInside)

        zeroDaysBeforeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel)))
        oneDayBeforeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel)))
        twoDaysBeforeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel)))
        threeDaysBeforeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel)))
        fourDaysBeforeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel)))
        fiveDaysBeforeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel)))
        sixDaysBeforeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel)))
        sevenDaysBeforeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectDaysBeforeLabel)))
    }
    
    override func constructSubviewHierarchy() {
        let customSpacing: CGFloat
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            customSpacing = 20
        default:
            customSpacing = 30
        }
        
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(descriptionLabel)
        containerStackView.setCustomSpacing(customSpacing, after: descriptionLabel)
        containerStackView.addArrangedSubview(cancelReminderButton)
        containerStackView.setCustomSpacing(customSpacing, after: cancelReminderButton)
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
        containerStackView.setCustomSpacing(customSpacing, after: daysBeforeContainerStackView)
        containerStackView.addArrangedSubview(timeOfDayLabel)
        containerStackView.addArrangedSubview(timeOfDayPickerView)
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
                descriptionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
                descriptionLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        default:
            NSLayoutConstraint.activate([
                descriptionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
                descriptionLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
        
        NSLayoutConstraint.activate([
            cancelReminderButton.heightAnchor.constraint(equalToConstant: 50),
            cancelReminderButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cancelReminderButton.trailingAnchor.constraint(equalTo: leadingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            daysBeforeLabel.heightAnchor.constraint(equalToConstant: 30)
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
            timeOfDayLabel.heightAnchor.constraint(equalToConstant: 30)
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
    
    var selectedDaysBeforeLabel: UIView? {
        willSet {
            selectedDaysBeforeLabel?.layer.borderWidth = 0
            selectedDaysBeforeLabel?.layer.borderColor = nil
        }
        didSet {
            selectedDaysBeforeLabel?.layer.borderWidth = 5
            selectedDaysBeforeLabel?.layer.borderColor = UIColor.compatibleLabel.cgColor
        }
    }
    
    @objc
    func didSelectDaysBeforeLabel(_ sender: UITapGestureRecognizer) {
        guard let daysBeforeLabel = sender.view as? ReminderCircleLabel else { return }
        
        selectedDaysBeforeLabel = daysBeforeLabel
        
        delegate?.didSelectDaysBefore(daysBeforeLabel.daysBefore.rawValue)
        
        daysBeforeLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6, options: .allowUserInteraction) {
            daysBeforeLabel.transform = .identity
        } completion: { _ in }
    }
}

// MARK: - Populatable

extension EventReminderView: Populatable {

    func populate(with content: Content) {
        self.descriptionLabel.text = content.descriptionLabelText
        self.timeOfDayPickerView.date = content.selectedTimeOfDayDate
        self.cancelReminderButton.isHidden = !content.notificationFound
        
        let daysBeforeLabels = [
            zeroDaysBeforeLabel,
            oneDayBeforeLabel,
            twoDaysBeforeLabel,
            threeDaysBeforeLabel,
            fourDaysBeforeLabel,
            fiveDaysBeforeLabel,
            sixDaysBeforeLabel,
            sevenDaysBeforeLabel
        ]
        
        if content.notificationFound {
            selectedDaysBeforeLabel = daysBeforeLabels[content.selectedDaysBeforeIndex]
        }
        
        daysBeforeLabels.forEach { daysBeforeLabel in
            if daysBeforeLabel.tag >= content.daysUntilEvent {
                daysBeforeLabel.alpha = 0.5
                daysBeforeLabel.isUserInteractionEnabled = false
            }
        }
    }

    func updateDescriptionLabel(text: String) {
        descriptionLabel.text = text
    }
}
