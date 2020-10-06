//
//  EventReminderViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/3/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventReminderDelegate {
    func didCancelNotificationRequest()
    func didUpdateNotificationRequest(_ notificationRequest: UNNotificationRequest)
}

class EventReminderViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constant {
        enum String {
            static let title = "Remind Me"
            static let saveButtonTitle = "Save"
        }
        enum Alert {
            static let actionCancel = "Cancel"
            static let actionConfirm = "Confirm"
            static let actionDismiss = "Dismiss"
            static let cancelTitle = "Are you sure?"
            static let cancelMessage = "You will no longer receive a notification for this event."
            static let errorTitle = "Error"
            static let errorMessage = "Please try again."
            static let permissionTitle = "Grant Permission"
            static let permissionMessage = "Please go to your notification settings to allow Date Dots notifications."
        }
    }
    
    // MARK: UI
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: Constant.String.saveButtonTitle, style: .done, target: self, action: #selector(saveReminder))
        return barButtonItem
    }()
    
    private lazy var baseView: EventReminderView = {
        let view = EventReminderView()
        view.delegate = self
        return view
    }()
    
    // MARK: Properties
    
    private let viewModel: EventReminderViewModel
    private var delegate: EventReminderDelegate
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(eventReminderDetails: EventReminderDetails, notificationRequest: UNNotificationRequest?, delegate: EventReminderDelegate) {
        self.viewModel = EventReminderViewModel(eventReminderDetails: eventReminderDetails, notificationRequest: notificationRequest)
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Lifecycle

    override func loadView() {
       view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        let content = viewModel.generateContent()
        baseView.populate(with: content)
    }
    
    private func configureView() {
        title = Constant.String.title
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    // MARK: User Actions
    
    @objc
    func saveReminder() {
        viewModel.saveReminder { (action, request) in
            switch action {
            case .dismissView:
                DispatchQueue.main.async {
                    if let request = request {
                        self.delegate.didUpdateNotificationRequest(request)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            case .displayAlertCancel:
                self.present(self.cancelAlert(), animated: true, completion: nil)
            case .displayAlertError:
                self.present(self.errorAlert(), animated: true, completion: nil)
            case .displayAlertPermissions:
                self.present(self.permissionsAlert(), animated: true, completion: nil)
            }
        }
    }
    
    private func cancelAlert() -> UIAlertController {
        let alert = UIAlertController(title: Constant.Alert.cancelTitle, message: Constant.Alert.cancelMessage, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: Constant.Alert.actionConfirm, style: .default) { alertAction in
            self.viewModel.cancelReminder()
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: Constant.Alert.actionCancel, style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    private func errorAlert() -> UIAlertController {
        let alert = UIAlertController(title: Constant.Alert.errorTitle, message: Constant.Alert.errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: Constant.Alert.actionDismiss, style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
    private func permissionsAlert() -> UIAlertController {
        let alert = UIAlertController(title: Constant.Alert.permissionTitle, message: Constant.Alert.permissionMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: Constant.Alert.actionDismiss, style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
}

extension EventReminderViewController: EventReminderViewDelegate {
    
    func didSelectDaysBefore(_ daysBefore: Int) {
        viewModel.selectedDaysBefore = daysBefore
        baseView.updateDescriptionLabel(text: viewModel.descriptionLabelText)
    }
    
    func didSelectTimeOfDay(date: Foundation.Date) {
        viewModel.selectedTimeOfDay = date
        baseView.updateDescriptionLabel(text: viewModel.descriptionLabelText)
    }
    
    func didTapCancelReminder() {
        viewModel.cancelReminder()
    }
}
