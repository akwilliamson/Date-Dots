//
//  ReminderView.swift
//  Date Dots
//
//  Created by Aaron Williamson on 4/29/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

protocol ReminderViewDelegate {
    func didTapReminderView(notificationRequest: UNNotificationRequest?)
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
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = viewModel.reminderFont
        label.text = viewModel.reminderText
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
    }
    
    // MARK: View Setup
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReminderView)))
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
    
    // MARK: Private Interface
    
    private func updateReminderText() {
        reminderLabel.text = viewModel.reminderText
    }
    
    // MARK: Actions
    
    @objc
    func didTapReminderView() {
        let notificationRequest = viewModel.getNotificationRequest()
        delegate.didTapReminderView(notificationRequest: notificationRequest)
    }
    
    // MARK: Public Interface
    
    public func updateNotificationRequest(_ notificationRequest: UNNotificationRequest) {
        viewModel.updateNotificationRequest(notificationRequest)
        updateReminderText()
    }
    
    public func clearNotificationRequest() {
        viewModel.clearNotificationRequest()
        updateReminderText()
    }
}
