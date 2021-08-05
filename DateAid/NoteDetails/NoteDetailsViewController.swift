//
//  NoteDetailsViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/3/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NoteDetailsViewOutputting: AnyObject {
    
    func setNavigation(title: String)
    func setNavigationBarDeleteButton()
    func setContent(_ content: NoteDetailsView.Content)
    
    func startEditTextField(isPlaceholder: Bool)
    func endEditTextField(isPlaceholder: Bool)
    func startEditTextView(isPlaceholder: Bool)
    func endEditTextView(isPlaceholder: Bool)
    
    func showAlert(title: String, description: String, shouldConfirm: Bool)
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: View Setup
    
    private func configureView() {
        view.backgroundColor = .compatibleSystemBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        baseView.delegate = self
    }
    
    // MARK: Navigation Bar
    
    @objc
    func deleteEvent() {
        presenter?.didTapDelete()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardSize.height/1.35
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}

// MARK: - NoteDetailsViewOutputting

extension NoteDetailsViewController: NoteDetailsViewOutputting {
    
    func setNavigation(title: String) {
        navigationItem.title = title
    }
    
    func setNavigationBarDeleteButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteEvent))
    }
    
    func setContent(_ content: NoteDetailsView.Content) {
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
    
    func showAlert(title: String, description: String, shouldConfirm: Bool = false) {
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        if shouldConfirm {
            let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.presenter?.didConfirmDelete()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
        } else {
            let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(dismissAction)
        }
        present(alertController, animated: true, completion: nil)
    }
}

extension NoteDetailsViewController: NoteDetailsViewDelegate {
    
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
    
    func didTapDeleteNote() {
        presenter?.didTapDelete()
    }
}
