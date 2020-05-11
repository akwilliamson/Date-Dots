//
//  ReminderView.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/29/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

protocol ReminderViewDelegate {
    func didTapReminderView()
}

class ReminderView: UIView {
    
    // MARK: UI
    
    private lazy var reminderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = UIColor.compatibleLabel
        imageView.image = UIImage(named: "sticky")?.withRenderingMode(.alwaysTemplate)
        return imageView
    }()

    private lazy var reminderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Noteworthy-Bold", size: 18)
//        label.textColor = event.color
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Properties

    let viewModel: ReminderViewViewModel
    let delegate: ReminderViewDelegate
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: ReminderViewViewModel, delegate: ReminderViewDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: .zero)
        configureView()
        constructSubviews()
        constrainSubviews()
        populateReminderLabel()
    }
    
    // MARK: View Setup
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func constructSubviews() {
        addSubview(reminderImageView)
        addSubview(reminderLabel)
    }
    
    private func  constrainSubviews(){
        NSLayoutConstraint.activate([
            reminderImageView.topAnchor.constraint(equalTo: topAnchor),
            reminderImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            reminderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            reminderImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            reminderLabel.topAnchor.constraint(equalTo: reminderImageView.topAnchor),
            reminderLabel.bottomAnchor.constraint(equalTo: reminderImageView.bottomAnchor),
            reminderLabel.leadingAnchor.constraint(equalTo: reminderImageView.leadingAnchor),
            reminderLabel.trailingAnchor.constraint(equalTo: reminderImageView.trailingAnchor)
        ])
    }
    
    // MARK: Actions
    
    @objc
    func didTapReminderView() {
        delegate.didTapReminderView()
    }
    
    // MARK: Helpers
    
    private func populateReminderLabel() {

        var daysPrior: Int? = nil
        var hourOfDay: Int? = nil
        
        if let notifications = UIApplication.shared.scheduledLocalNotifications {
            for notification in notifications {
                guard let notificationID = notification.userInfo?["date"] as? String else { continue }
                
                let dateObjectURL = String(describing: viewModel.eventID)
                
                if notificationID == dateObjectURL {
                    daysPrior = Int(notification.userInfo?["daysPrior"] as! String)
                    hourOfDay = Int(notification.userInfo?["hoursAfter"] as! String)
                }
            }
        }

        reminderLabel.text = viewModel.textForReminderLabel(for: daysPrior, hourOfDay: hourOfDay)
    }
}
