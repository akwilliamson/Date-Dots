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

protocol SetNotificationDelegate {
    func reloadNotificationView()
}

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

    private let addressContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAddressView)))
        view.isUserInteractionEnabled = true
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.navigationGray.cgColor
        view.clipsToBounds = true
        return view
    }()

    private let addressLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var stampImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "stamp")
        return imageView
    }()

    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = event.color
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Noteworthy-Bold", size: 20)
        label.textAlignment = .center
        label.text = viewModel.textForAddressLabel(for: event)
        return label
    }()

    // MARK: UI - Reminders

    private lazy var reminderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showReminderView)))
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = UIColor.navigationGray
        imageView.image = UIImage(named: "sticky")?.withRenderingMode(.alwaysTemplate)
        return imageView
    }()

    private lazy var reminderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Noteworthy-Bold", size: 20)
        label.textColor = event.color
        label.textAlignment = .center
        return label
    }()
    
    // MARK: UI - Circle Icons
    
    private let circleImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 50
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let addressCircleImageView: CircleImageView = {
        let circleImageView = CircleImageView()
        circleImageView.image = UIImage(named: "envelope")?.withRenderingMode(.alwaysTemplate)
        circleImageView.tintColor = .navigationGray
        circleImageView.layer.borderColor = UIColor.navigationGray.cgColor
        return circleImageView
    }()

    private let reminderCircleImageView: CircleImageView = {
        let circleImageView = CircleImageView()
        circleImageView.image = UIImage(named: "reminder")?.withRenderingMode(.alwaysTemplate)
        circleImageView.tintColor = .navigationGray
        circleImageView.layer.borderColor = UIColor.navigationGray.cgColor
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
        button.backgroundColor = event.color
        button.setTitle("Gift Ideas", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        return button
    }()
    
    private lazy var eventPlansButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = event.color
        button.setTitle("Event Plans", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        return button
    }()

    private lazy var otherNotesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = event.dateType.color
        button.setTitle("Other Notes", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        return button
    }()

    // MARK: Properties

    private let event: Date

    var managedContext: NSManagedObjectContext?
    var localNotificationFound: Bool?

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
        populateAlertViews()
    }
    
    private func populateAlertViews() {

        var daysPrior: Int? = nil
        var hourOfDay: Int? = nil
        
        if let notifications = UIApplication.shared.scheduledLocalNotifications {
            for notification in notifications {
                guard let notificationID = notification.userInfo?["date"] as? String else { continue }
                
                let dateObjectURL = String(describing: event.objectID.uriRepresentation())
                
                if notificationID == dateObjectURL {
                    daysPrior = Int(notification.userInfo?["daysPrior"] as! String)
                    hourOfDay = Int(notification.userInfo?["hoursAfter"] as! String)
                }
            }
        }

        reminderLabel.text = viewModel.textForReminderLabel(for: daysPrior, hourOfDay: hourOfDay)
    }

    private func configureView() {
        title = event.abbreviatedName
        view.backgroundColor = .white
    }
    
    private func constructSubviews() {
        view.addSubview(eventLabelStackView)
        eventLabelStackView.addArrangedSubview(dateLabel)
        eventLabelStackView.addArrangedSubview(ageLabel)
        eventLabelStackView.addArrangedSubview(countdownLabel)
        view.addSubview(addressContainerView)
        addressContainerView.addSubview(stampImageView)
        addressContainerView.addSubview(addressLabel)
        view.addSubview(reminderImageView)
        reminderImageView.addSubview(reminderLabel)
        view.addSubview(circleImageStackView)
        circleImageStackView.addArrangedSubview(addressCircleImageView)
        circleImageStackView.addArrangedSubview(reminderCircleImageView)
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
            circleImageStackView.bottomAnchor.constraint(equalTo: notesStackView.topAnchor, constant: -20),
            circleImageStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            addressCircleImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5),
            addressCircleImageView.heightAnchor.constraint(equalTo: addressCircleImageView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            reminderImageView.topAnchor.constraint(equalTo: eventLabelStackView.bottomAnchor, constant: 40),
            reminderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reminderImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2),
            reminderImageView.heightAnchor.constraint(equalTo: reminderImageView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            reminderLabel.topAnchor.constraint(equalTo: reminderImageView.topAnchor),
            reminderLabel.bottomAnchor.constraint(equalTo: reminderImageView.bottomAnchor),
            reminderLabel.leadingAnchor.constraint(equalTo: reminderImageView.leadingAnchor),
            reminderLabel.trailingAnchor.constraint(equalTo: reminderImageView.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            addressContainerView.topAnchor.constraint(equalTo: eventLabelStackView.bottomAnchor, constant: 40),
            addressContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addressContainerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.5),
            addressContainerView.heightAnchor.constraint(equalTo: addressContainerView.widthAnchor, multiplier: 0.5)
        ])
        NSLayoutConstraint.activate([
            stampImageView.topAnchor.constraint(equalTo: addressContainerView.topAnchor, constant: 8),
            stampImageView.trailingAnchor.constraint(equalTo: addressContainerView.trailingAnchor, constant: -8),
            stampImageView.widthAnchor.constraint(equalToConstant: 25),
            stampImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: addressContainerView.topAnchor),
            addressLabel.bottomAnchor.constraint(equalTo: addressContainerView.bottomAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: addressContainerView.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: addressContainerView.trailingAnchor)
        ])
    }
    
    private func addTapGesture(to view: UIView, action: String) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(action))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func showReminderView() {
//        performSegue(withIdentifier: "ShowNotification", sender: self)
    }
    
    @objc
    private func showAddressView() {
//        performSegue(withIdentifier: "ShowAddress", sender: self)
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
            addDateVC.notificationDelegate = self
        }
        if segue.identifier == "ShowNotes" {
            let notesTableVC = segue.destination as! NotesTableVC
            notesTableVC.managedContext = managedContext
            notesTableVC.typeColor = event.color
            notesTableVC.dateObject = event
        }
        if segue.identifier == "ShowNotification" {
            let singlePushSettingsVC = segue.destination as! SinglePushSettingsVC
            singlePushSettingsVC.dateObject = event
            singlePushSettingsVC.notificationDelegate = self
        }
        if segue.identifier == "ShowAddress" {
            let editDetailsVC = segue.destination as! EditDetailsVC
            editDetailsVC.dateObject = event
            editDetailsVC.managedContext = managedContext
            editDetailsVC.addressDelegate = self
        }
    }
}

// MARK: - SetNotificationDelegate

extension DateDetailsViewController: SetNotificationDelegate {
    
    func reloadNotificationView() {
        localNotificationFound = false
    }
}

// MARK: - SetAddressDelegate

extension DateDetailsViewController: SetAddressDelegate {

    func repopulateAddressFor(dateObject date: Date) {
        addressLabel.text = viewModel.textForAddressLabel(for: date)
    }
}
