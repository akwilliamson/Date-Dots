//
//  NoteDetailsViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/3/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NoteDetailsViewOutputting: class {
    
    func setContent(_ content: NoteDetailsView.Content)
    
    func startEditTextField(isPlaceholder: Bool)
    func endEditTextField(isPlaceholder: Bool)
    func startEditTextView(isPlaceholder: Bool)
    func endEditTextView(isPlaceholder: Bool)
    
    func showAlert(title: String, description: String)
}

class NoteDetailsViewController: UIViewController {
    
    // MARK: UI
    
    private let baseView = NoteDetailsView()
    
    // MARK: Properties
    
    weak var presenter: NoteDetailsEventHandling?
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        presenter?.viewDidLoad()
    }
    
    // MARK: View Setup
    
    private func configureView() {
        view.backgroundColor = .compatibleSystemBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing)))
        baseView.delegate = self
    }
    
    // MARK: Navigation Bar
    
    @objc
    func saveEvent() {
        presenter?.didTapSave()
    }
    
    @objc
    func editEvent() {
        presenter?.didTapEdit()
    }
}

// MARK: - NoteDetailsViewOutputting

extension NoteDetailsViewController: NoteDetailsViewOutputting {
    
    func setContent(_ content: NoteDetailsView.Content) {
        if content.isNewNote {
            navigationItem.title = "New Note"
        } else {
            navigationItem.title = "Note Details"
        }
        
        if content.isEditable {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveEvent))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editEvent))
        }
        
        baseView.populate(with: content)
    }
    
    func startEditTextField(isPlaceholder: Bool) {
        baseView.startEditTextField(isPlaceholder: isPlaceholder)
    }
    
    func endEditTextField(isPlaceholder: Bool) {
        baseView.endEditTextField(isPlaceholder: isPlaceholder)
    }
    
    func startEditTextView(isPlaceholder: Bool) {
        baseView.startEditTextView(isPlaceholder: isPlaceholder)
    }
    
    func endEditTextView(isPlaceholder: Bool) {
        baseView.endEditTextView(isPlaceholder: isPlaceholder)
    }
    
    func showAlert(title: String, description: String) {
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension NoteDetailsViewController: NoteDetailsViewDelegate {
    
    func didTapEventSelection() {
        presenter?.willChooseEvent()
    }
    
    func textFieldDidBeginEditing() {
        presenter?.didBeginEditingSubject()
    }
    
    func textFieldDidChange(text: String?) {
        presenter?.didChangeSubject(text: text)
    }
    
    func textFieldDidEndEditing() {
        presenter?.didEndEditingSubject()
    }
    
    func textViewDidBeginEditing() {
        presenter?.didBeginEditingDescription()
    }
    
    func textViewDidChange(text: String?) {
        presenter?.didChangeDescription(text: text)
    }
    
    func textViewDidEndEditing() {
        presenter?.didEndEditingDescription()
    }
    
    func didTapViewEventDetails() {
        presenter?.didTapViewEventDetails()
    }
    
    func didTapDeleteNote() {
        presenter?.didTapDelete()
    }
}
