//
//  DateDetailsViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/23/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class DateDetailsViewController: UIViewController {

    // MARK: UI - Details

    private let eventLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var dateLabel: EventCircleLabel = {
        let eventCircleLabel = EventCircleLabel(dateType: event.dateType)
        eventCircleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        eventCircleLabel.text = viewModel.textForDateLabel(for: event)
        return eventCircleLabel
    }()
    
    private lazy var ageLabel: EventCircleLabel = {
        let eventCircleLabel = EventCircleLabel(dateType: event.dateType)
        eventCircleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 40)
        eventCircleLabel.text = viewModel.textForAgeLabel(for: event)
        return eventCircleLabel
    }()

    private lazy var countdownLabel: EventCircleLabel = {
        let eventCircleLabel = EventCircleLabel(dateType: event.dateType)
        eventCircleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        eventCircleLabel.text = viewModel.textForCountdownLabel(for: event)
        return eventCircleLabel
    }()

    // MARK: UI - Address

    private lazy var addressView: AddressView = {
        let viewModel = AddressViewViewModel(address: event.address, dateType: event.dateType)
        let view = AddressView(viewModel: viewModel)
        return view
    }()

    // MARK: UI - Reminder
    
    private lazy var reminderView: ReminderView = {
        let viewModel = ReminderViewViewModel(eventID: event.objectID.uriRepresentation())
        let view = ReminderView(viewModel: viewModel, delegate: self)
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
        circleImageView.tintColor = event.color
        circleImageView.layer.borderColor = UIColor.textGray.cgColor
        return circleImageView
    }()

    private lazy var reminderCircleImageView: CircleImageView = {
        let circleImageView = CircleImageView()
        circleImageView.isUserInteractionEnabled = true
        circleImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReminderIcon)))
        circleImageView.image = UIImage(named: "reminder")?.withRenderingMode(.alwaysTemplate)
        circleImageView.tintColor = .textGray
        circleImageView.layer.borderColor = UIColor.textGray.cgColor
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
        button.backgroundColor = event.color
        button.setTitle("Gift Ideas", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        return button
    }()
    
    private lazy var eventPlansButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapEventPlans), for: .touchUpInside)
        button.backgroundColor = event.color
        button.setTitle("Event Plans", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        return button
    }()

    private lazy var otherNotesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapOtherNotes), for: .touchUpInside)
        button.backgroundColor = event.dateType.color
        button.setTitle("Other Notes", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        return button
    }()

    // MARK: Properties

    private let event: Date

    var managedContext: NSManagedObjectContext?

    private let viewModel = DateDetailsViewModel()
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(event: Date) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        constructSubviews()
        constrainSubviews()
        setButtonState()
    }

    private func setButtonState() {
        switch viewModel.toggledEvent {
        case .address:
            addressCircleImageView.tintColor = event.color
            addressCircleImageView.layer.borderColor = event.color.cgColor
            addressView.isHidden = false
            reminderCircleImageView.tintColor = .textGray
            reminderCircleImageView.layer.borderColor = UIColor.textGray.cgColor
            reminderView.isHidden = true
        case .reminder:
            addressCircleImageView.tintColor = .textGray
            addressCircleImageView.layer.borderColor = UIColor.textGray.cgColor
            addressView.isHidden = true
            reminderCircleImageView.tintColor = event.color
            reminderCircleImageView.layer.borderColor = event.color.cgColor
            reminderView.isHidden = false
        }
    }

    private func configureView() {
        title = event.abbreviatedName
        view.backgroundColor = .standardBackgroundColor
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
            giftIdeasButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            toggleButtonStackView.bottomAnchor.constraint(equalTo: notesStackView.topAnchor, constant: -20),
            toggleButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            addressCircleImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5),
            addressCircleImageView.heightAnchor.constraint(equalTo: addressCircleImageView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            reminderView.topAnchor.constraint(equalTo: eventLabelStackView.bottomAnchor, constant: 10),
            reminderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reminderView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.7),
            reminderView.heightAnchor.constraint(equalTo: reminderView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            addressView.topAnchor.constraint(equalTo: eventLabelStackView.bottomAnchor, constant: 40),
            addressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addressView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.5),
            addressView.heightAnchor.constraint(equalTo: addressView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    // MARK: Actions
    
    @objc
    private func didTapAddressIcon() {
        viewModel.toggledEvent = .address
        setButtonState()
    }
    
    @objc
    private func didTapReminderIcon() {
        viewModel.toggledEvent = .reminder
        setButtonState()
    }

    @objc
    private func didTapGiftIdeas() {
        let viewController = NoteViewController(event: event, noteType: .gifts)
        viewController.managedContext = managedContext
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func didTapEventPlans() {
        let viewController = NoteViewController(event: event, noteType: .plans)
        viewController.managedContext = managedContext
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func didTapOtherNotes() {
        let viewController = NoteViewController(event: event, noteType: .other)
        viewController.managedContext = managedContext
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Transition
    
    @IBAction func unwindToDateDetails(_ segue: UIStoryboardSegue) {
        self.loadView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditDate" {
            let addDateVC = segue.destination as! AddDateVC
            addDateVC.isBeingEdited = true
            addDateVC.dateToSave = event
            addDateVC.managedContext = managedContext
        }
        if segue.identifier == "ShowNotification" {
            let singlePushSettingsVC = segue.destination as! SinglePushSettingsVC
            singlePushSettingsVC.dateObject = event
        }
        if segue.identifier == "ShowAddress" {
            let editDetailsVC = segue.destination as! EditDetailsVC
            editDetailsVC.dateObject = event
            editDetailsVC.managedContext = managedContext
        }
    }
}

extension DateDetailsViewController: ReminderViewDelegate {

    func didTapReminderView() {
        // Navigation to notifications
    }
}
