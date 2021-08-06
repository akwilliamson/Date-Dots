//
//  EventCreationViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/25/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventCreationViewOutputting: AnyObject {
    
    // Navigation Title
    func configureNavigation(title: String)
    func configureNavigationDeleteButton()
    func configureNavigationSaveButton()
    
    // Base View
    func populateView(content: EventCreationView.Content)
    func populateDays(_ days: [String])
    func selectEventType(_ eventType: EventType)
    func selectMonth(index: Int)
    func selectYear(index: Int)
    func selectDay(index: Int)
    
    // Alerts
    func showInputError()
    func showSaveError()
    func showConfirmDelete()
}

class EventCreationViewController: UIViewController {
    
    // MARK: UI
    
    private let baseView = EventCreationView()
    
    // MARK: Properties
    
    weak var presenter: EventCreationEventHandling?
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        view = baseView
        baseView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        baseView.endEditing(true)
    }
    
    // MARK: Actions
    
    @objc
    func saveNewEvent() {
        presenter?.didTapSave()
    }
    
    @objc
    func deleteEvent() {
        presenter?.didTapDelete()
    }
}

// MARK: EventCreationViewOutputting

extension EventCreationViewController: EventCreationViewOutputting {
    
    func configureNavigation(title: String) {
        navigationItem.title = title
    }
    
    func configureNavigationDeleteButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteEvent))
    }
    
    func configureNavigationSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNewEvent))
    }
    
    func populateView(content: EventCreationView.Content) {
        baseView.populate(with: content)
    }
    
    func populateDays(_ days: [String]) {
        baseView.populateDays(days: days)
        baseView.reloadAllComponents()
    }
    
    func selectEventType(_ eventType: EventType) {
        baseView.selectEventType(eventType)
    }
    
    func selectMonth(index: Int) {
        baseView.selectMonth(row: index)
    }
    
    func selectYear(index: Int) {
        baseView.selectYear(row: index)
    }
    
    func selectDay(index: Int) {
        baseView.selectDay(row: index)
    }
    
    func showInputError() {
        let alertController = UIAlertController(title: "Save Error", message: "Please add a name before saving", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showSaveError() {
        let alertController = UIAlertController(title: "Save Error", message: "Something went wrong, please try again", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showConfirmDelete() {
        let alertController = UIAlertController(title: "Confirm Delete", message: "This event will be permanently deleted.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.presenter?.didConfirmDelete()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: EventsViewDelegate

extension EventCreationViewController: EventCreationViewDelegate {
    
    func didToggleYearPicker(isOn: Bool) {
        presenter?.didToggleYearPicker(isOn: isOn)
    }
    
    func didSelectEventType(eventType: EventType) {
        presenter?.didSelectEventType(eventType: eventType)
    }
    
    func didChangeFirstName(text: String?) {
        guard let text = text else { return }
        presenter?.didChangeFirstName(text: text)
    }
    
    func didChangeLastName(text: String?) {
        guard let text = text else { return }
        presenter?.didChangeLastName(text: text)
    }
    
    func didChangeAddress(text: String?) {
        guard let text = text else { return }
        presenter?.didChangeAddress(text: text)
    }
    
    func didChangeRegion(text: String?) {
        guard let text = text else { return }
        presenter?.didChangeRegion(text: text)
    }
    
    func didSelectPicker(row: Int, in component: Int) {
        presenter?.didSelectPickerRow(row: row, in: component)
    }
    
    func textFieldDidReturn() {
        presenter?.textFieldDidReturn()
    }
}
