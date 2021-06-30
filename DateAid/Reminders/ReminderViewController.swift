//
//  ReminderViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/3/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

protocol ReminderViewOutputting: AnyObject {
    
    func configureNavigation(title: String)
    func populateView(content: ReminderView.Content)
    func configureNavigationButton(title: String)
    func didUpdateScheduled(text: String)
    func presentAlertWillDelete(title: String, body: String, confirm: String, dismiss: String)
    func presentAlertErrorSave(title: String, body: String, dismiss: String)
    func presentAlertErrorAuth(title: String, body: String, confirm: String, dismiss: String)
}

class ReminderViewController: UIViewController {
    
    // MARK: UI
    
    private let baseView = ReminderView()
    
    // MARK: Properties
    
    weak var presenter: ReminderEventHandling?
    
    // MARK: Lifecycle

    override func loadView() {
       view = baseView
       baseView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    // MARK: User Actions
    
    @objc
    func didPressSave() {
        presenter?.didPressSaveReminder()
    }
}

// MARK: - ReminderViewOutputting

extension ReminderViewController: ReminderViewOutputting {
    
    func configureNavigation(title: String) {
        navigationItem.title = title
    }
    
    func populateView(content: ReminderView.Content) {
        baseView.populate(with: content)
    }
    
    func configureNavigationButton(title: String) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: title,
            style: .done,
            target: self,
            action: #selector(didPressSave)
        )
    }
    
    func didUpdateScheduled(text: String) {
        baseView.updateScheduledLabel(text: text)
    }
    
    func presentAlertErrorAuth(title: String, body: String, confirm: String, dismiss: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: confirm, style: .default) { _ in
            guard
                let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(settingsUrl)
            else {
                return
            }

            UIApplication.shared.open(settingsUrl) { _ in }
        })
    }
    
    func presentAlertErrorSave(title: String, body: String, dismiss: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: dismiss, style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentAlertWillDelete(title: String, body: String, confirm: String, dismiss: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: confirm, style: .default) { _ in
            self.presenter?.didConfirmDeleteReminder()
        })
        alert.addAction(UIAlertAction(title: dismiss, style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - ReminderViewDelegate

extension ReminderViewController: ReminderViewDelegate {
    
    func didSelectDayPrior(_ dayPrior: Int) {
        presenter?.didSelectDayPrior(dayPrior)
    }
    
    func didChangeTimeOfDay(date: Date) {
        presenter?.didChangeTimeOfDay(date)
    }
    
    func didPressDelete() {
        presenter?.didPressDeleteReminder()
    }
}
