//
//  EventDetailsViewController.swift
//  Date Dots
//
//  Created by Aaron Williamson on 6/23/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

protocol EventSetupDelegate {
    func updateEvent(_ event: Event)
}

class EventDetailsViewControllerz: UIViewController {

    // MARK: UI - Details
    
    private lazy var editBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editEvent))
        return barButtonItem
    }()

    private let eventLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var dateLabel: EventCircleLabel = {
        let eventCircleLabel = EventCircleLabel(color: viewModel.eventColor)
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            eventCircleLabel.font = FontType.avenirNextDemiBold(20).font
        default:
            eventCircleLabel.font = FontType.avenirNextDemiBold(30).font
        }
        
        return eventCircleLabel
    }()
    
    private lazy var ageLabel: EventCircleLabel = {
        let eventCircleLabel = EventCircleLabel(color: viewModel.eventColor)
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            eventCircleLabel.font = FontType.avenirNextDemiBold(30).font
        default:
            eventCircleLabel.font = FontType.avenirNextDemiBold(40).font
        }
        
        return eventCircleLabel
    }()

    private lazy var countdownLabel: EventCircleLabel = {
        let eventCircleLabel = EventCircleLabel(color: viewModel.eventColor)
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            eventCircleLabel.font = FontType.avenirNextDemiBold(20).font
        default:
            eventCircleLabel.font = FontType.avenirNextDemiBold(30).font
        }
        
        return eventCircleLabel
    }()

    // MARK: UI - Address

    private lazy var addressView: AddressView = {
        let vm = AddressViewViewModel(address: viewModel.address, eventType: viewModel.eventType)
        let view = AddressView(viewModel: vm, delegate: self)
        return view
    }()

    // MARK: UI - Reminder
    
    private lazy var reminderView: ReminderView = {
        let view = ReminderView(viewModel: ReminderViewViewModel(), delegate: self)
        view.isHidden = true
        return view
    }()
    
    // MARK: UI - Circle Icons
    
    private let toggleButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 50
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var addressCircleImageView: CircleImageView = {
        let circleImageView = CircleImageView()
        circleImageView.isUserInteractionEnabled = true
        circleImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddressIcon)))
        circleImageView.image = UIImage(named: "envelope")?.withRenderingMode(.alwaysTemplate)
        return circleImageView
    }()

    private lazy var reminderCircleImageView: CircleImageView = {
        let circleImageView = CircleImageView()
        circleImageView.isUserInteractionEnabled = true
        circleImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReminderIcon)))
        circleImageView.image = UIImage(named: "reminder")?.withRenderingMode(.alwaysTemplate)
        return circleImageView
    }()
    
    // MARK: UI - Notes

    private let notesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var giftIdeasButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapGiftIdeas), for: .touchUpInside)
        button.setTitle("Gift Ideas", for: .normal)
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            button.titleLabel?.font = FontType.avenirNextDemiBold(25).font
        default:
            button.titleLabel?.font = FontType.avenirNextDemiBold(30).font
        }
        
        return button
    }()
    
    private lazy var eventPlansButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapEventPlans), for: .touchUpInside)
        button.setTitle("Event Plans", for: .normal)
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            button.titleLabel?.font = FontType.avenirNextDemiBold(25).font
        default:
            button.titleLabel?.font = FontType.avenirNextDemiBold(30).font
        }
        
        return button
    }()

    private lazy var otherNotesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapOtherNotes), for: .touchUpInside)
        button.setTitle("Other Notes", for: .normal)
        
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            button.titleLabel?.font = FontType.avenirNextDemiBold(25).font
        default:
            button.titleLabel?.font = FontType.avenirNextDemiBold(30).font
        }
        
        return button
    }()

    // MARK: Properties
    
    private let viewModel: EventDetailsViewModel
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(event: Event) {
        self.viewModel = EventDetailsViewModel(event: event)
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        constructSubviews()
        constrainSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateText()
        setStyle()
    }

    private func configureView() {
        navigationItem.rightBarButtonItem = editBarButtonItem
        view.backgroundColor = .compatibleSystemBackground
        fetchAndStoreNotification()
    }
    
    private func constructSubviews() {
        view.addSubview(eventLabelStackView)
        eventLabelStackView.addArrangedSubview(dateLabel)
        eventLabelStackView.addArrangedSubview(ageLabel)
        eventLabelStackView.addArrangedSubview(countdownLabel)
        view.addSubview(addressView)
        view.addSubview(reminderView)
        view.addSubview(toggleButtonStackView)
        toggleButtonStackView.addArrangedSubview(addressCircleImageView)
        toggleButtonStackView.addArrangedSubview(reminderCircleImageView)
        view.addSubview(notesStackView)
        notesStackView.addArrangedSubview(giftIdeasButton)
        notesStackView.addArrangedSubview(eventPlansButton)
        notesStackView.addArrangedSubview(otherNotesButton)
    }

    private func constrainSubviews() {
        NSLayoutConstraint.activate([
            eventLabelStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            eventLabelStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            eventLabelStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            ageLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/4),
            ageLabel.heightAnchor.constraint(equalTo: ageLabel.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            notesStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            notesStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            notesStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            giftIdeasButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06)
        ])

        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            NSLayoutConstraint.activate([
                toggleButtonStackView.bottomAnchor.constraint(equalTo: notesStackView.topAnchor, constant: -10),
                toggleButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            NSLayoutConstraint.activate([
                addressView.topAnchor.constraint(equalTo: eventLabelStackView.bottomAnchor, constant: 20),
                addressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                addressView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.5),
                addressView.heightAnchor.constraint(equalTo: addressView.widthAnchor, multiplier: 0.5)
            ])
            NSLayoutConstraint.activate([
                reminderView.topAnchor.constraint(equalTo: eventLabelStackView.bottomAnchor, constant: 5),
                reminderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                reminderView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2.1),
                reminderView.heightAnchor.constraint(equalTo: reminderView.widthAnchor)
            ])
        default:
            NSLayoutConstraint.activate([
                toggleButtonStackView.bottomAnchor.constraint(equalTo: notesStackView.topAnchor, constant: -20),
                toggleButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            NSLayoutConstraint.activate([
                addressView.topAnchor.constraint(equalTo: eventLabelStackView.bottomAnchor, constant: 40),
                addressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                addressView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.3),
                addressView.heightAnchor.constraint(equalTo: addressView.widthAnchor, multiplier: 0.5)
            ])
            NSLayoutConstraint.activate([
                reminderView.topAnchor.constraint(equalTo: eventLabelStackView.bottomAnchor, constant: 10),
                reminderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                reminderView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.8),
                reminderView.heightAnchor.constraint(equalTo: reminderView.widthAnchor)
            ])
        }
    }
    
    private func fetchAndStoreNotification() {
        viewModel.getNotification { notificationRequest in
            guard let notificationRequest = notificationRequest else { return }
            DispatchQueue.main.async {
                self.reminderView.updateNotificationRequest(notificationRequest)
            }
        }
    }
    
    private func populateText() {
        title = viewModel.titleText
        dateLabel.text = viewModel.dateLabelText
        ageLabel.text = viewModel.ageLabelText
        countdownLabel.text = viewModel.countdownLabelText
        addressView.updateAddress(viewModel.address)
        addressView.updateEventType(viewModel.eventType)
    }
    
    private func setStyle() {
        dateLabel.updateColor(to: viewModel.eventColor)
        ageLabel.updateColor(to: viewModel.eventColor)
        countdownLabel.updateColor(to: viewModel.eventColor)
        setToggleStyle()
        giftIdeasButton.backgroundColor = viewModel.eventColor
        eventPlansButton.backgroundColor = viewModel.eventColor
        otherNotesButton.backgroundColor = viewModel.eventColor
    }
    
    private func setToggleStyle() {
        addressCircleImageView.tintColor = viewModel.colorForToggle(toggledEvent: .address)
        addressCircleImageView.layer.borderColor = viewModel.colorForToggle(toggledEvent: .address).cgColor
        reminderCircleImageView.tintColor = viewModel.colorForToggle(toggledEvent: .reminder)
        reminderCircleImageView.layer.borderColor = viewModel.colorForToggle(toggledEvent: .reminder).cgColor
    }
    
    // MARK: Actions
    
    @objc
    func editEvent() {
        let viewController = EventSetupViewController()
        viewController.event = viewModel.event
        viewController.eventSetupDelegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func didTapAddressIcon() {
        viewModel.didToggleEvent(.address)
        addressView.isHidden = false
        reminderView.isHidden = true
        setToggleStyle()
    }
    
    @objc
    private func didTapReminderIcon() {
        viewModel.didToggleEvent(.reminder)
        addressView.isHidden = true
        reminderView.isHidden = false
        setToggleStyle()
    }

    @objc
    private func didTapGiftIdeas() {
        let viewController = EventNoteViewController(event: viewModel.event, noteType: .gifts)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func didTapEventPlans() {
        let viewController = EventNoteViewController(event: viewModel.event, noteType: .plans)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func didTapOtherNotes() {
        let viewController = EventNoteViewController(event: viewModel.event, noteType: .other)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension EventDetailsViewControllerz: ReminderViewDelegate {

    @objc
    func didTapReminderView(notificationRequest: UNNotificationRequest?) {
        let eventReminderDetails = viewModel.generateEventReminderDetails()
        
        let eventReminderViewController = EventReminderViewController(
            eventReminderDetails: eventReminderDetails,
            notificationRequest: notificationRequest,
            delegate: self
        )

        navigationController?.pushViewController(eventReminderViewController, animated: true)
    }
}

extension EventDetailsViewControllerz: AddressViewDelegate {

    @objc func didTapAddressView() {
        editEvent()
    }
}

extension EventDetailsViewControllerz: EventSetupDelegate {
    
    func updateEvent(_ event: Event) {
        viewModel.updateEvent(event)
    }
}

extension EventDetailsViewControllerz: EventReminderDelegate {
    
    func didCancelNotificationRequest() {
        reminderView.clearNotificationRequest()
    }
    
    func didUpdateNotificationRequest(_ notificationRequest: UNNotificationRequest) {
        reminderView.updateNotificationRequest(notificationRequest)
    }
}
