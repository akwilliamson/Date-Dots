//
//  DateSetupViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/3/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

enum DateSetupType {
    case add
    case edit
}

class DateSetupViewController: UIViewController {
    
    private enum Constant {
        static let title = "New Event"
        static let keyboardHeight: CGFloat = 216
    }
    
    // MARK: UI
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveEvent))
        return barButtonItem
    }()
    
    private lazy var baseView: DateSetupView = {
        let view = DateSetupView()
        view.delegate = self
        return view
    }()
    
    // MARK: Properties
    
    private let viewModel = DateSetupViewModel()

    var event: Date?
    var managedContext = CoreDataStack().managedObjectContext
    
    // MARK: Lifecycle
 
    override func loadView() {
        view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        if let event = event {
            baseView.populate(with: viewModel.generateEditContent(for: event))
        } else {
            baseView.populate(with: viewModel.generateAddContent())
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func configureView() {
        title = Constant.title
        navigationItem.rightBarButtonItem = saveBarButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Actions

    @objc
    func saveEvent() {
        saveContext()
    }
    
    private func saveContext() {
        guard
            let eventName = viewModel.eventName,
            let eventType = viewModel.eventType,
            let eventDate = viewModel.eventDate,
            let eventEntity = NSEntityDescription.entity(forEntityName: "Date", in: managedContext),
            let addressEntity = NSEntityDescription.entity(forEntityName: "Address", in: managedContext)
        else {
            return
        }
        
        let event = Date(entity: eventEntity, insertInto: managedContext)
        event.name = eventName
        event.type = eventType.rawValue
        event.date = eventDate
        event.abbreviatedName = viewModel.eventNameAbbreviated
        event.equalizedDate = viewModel.eventDateString
        
        let address = Address(entity: addressEntity, insertInto: managedContext)
        address.street = viewModel.eventAddressOne
        address.region = viewModel.eventAddressTwo
        
        event.address = address

        managedContext.trySave { (success, error) in
            if success {
                navigationController?.popViewController(animated: true)
            } else if let error = error {
                showAlert(withError: error.localizedDescription)
            } else {
                showAlert(withError: "Uh oh, something went wrong. Please try again.")
            }
        }
    }
    
    @objc
    func keyboardWillShow(_ notification: NSNotification) {
        let adjustedViewHeight = viewModel.adjustedViewHeight(willShow: true, yOrigin: view.frame.origin.y, for: notification)

        view.frame.origin.y += adjustedViewHeight
    }

    @objc
    func keyboardWillHide(_ notification: NSNotification) {
        let adjustedViewHeight = viewModel.adjustedViewHeight(willShow: false, yOrigin: view.frame.origin.y, for: notification)

        view.frame.origin.y += adjustedViewHeight
    }

    private func showAlert(withError errorDescription: String) {
        let alert = UIAlertController(title: "Save Failed", message: errorDescription, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - DateSetupViewDelegate

extension DateSetupViewController: DateSetupViewDelegate {
    
    func didBeginEditingFor(inputType: DateSetupInputType, currentText: String?, _ completion: (String?, UIColor) -> Void) {
        let input = viewModel.inputValuesFor(inputType, currentText: currentText, isEditing: true)

        completion(input.text, input.textColor)
    }
    
    func didEndEditingFor(inputType: DateSetupInputType, currentText: String?, _ completion: (String?, UIColor) -> Void) {
        let input = viewModel.inputValuesFor(inputType, currentText: currentText, isEditing: false)
        
        completion(input.text, input.textColor)
    }
    
    func firstNameDidChange(text: String?) {
        title = text.isEmptyOrNil ? Constant.title : text
    }
    
    func eventDateTypeSelected(dateType: DateType, isSelected: Bool) {
        if isSelected {
            viewModel.eventType = dateType
        } else {
            viewModel.eventType = nil
        }
    }
    
    func datePickerValueChangedTo(date: Foundation.Date) {
        viewModel.eventDate = date
    }
}
