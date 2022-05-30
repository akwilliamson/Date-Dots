//
//  EventsViewController.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/8/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import CoreData
import MessageUI
import StoreKit
import UIKit

protocol EventsViewOutputting: AnyObject {
 
    // Navigation View
    func configureNavigation(title: String)
    func configureNavigation(state: EventsPresenter.NavigationState)

    // Base View
    func toggleDotFor(eventType: EventType, isSelected: Bool)
    func toggleDotFor(noteType: NoteType, isSelected: Bool)
    
    func hideNoteDots()
    func showNoteDots()

    func populateView(activeEvents: [Event], activeNoteTypes: [NoteType])
    func reloadView()
    
    func presentMailComposer(recipient: String, subject: String, body: String)
    func presentAppReviewModal()
}

class EventsViewController: UIViewController {

    // MARK: UI

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private var composeButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeButtonPressed))
    }
    
    private var searchButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
    }
    
    private var cancelButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
    }
    
    private lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }()
    
    private let baseView = EventsView()

    // MARK: Properties

    var presenter: EventsEventHandling?

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        /// In case search bar was previously active, reset to initial bar buttons on appear
        navigationItem.rightBarButtonItems = [addButton, searchButton]
        navigationItem.leftBarButtonItem = composeButton
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: Actions
    
    @objc
    func composeButtonPressed() {
        presenter?.composeButtonPressed()
    }
    
    @objc
    func searchButtonPressed() {
        presenter?.searchButtonPressed()
    }
    
    @objc
    func cancelButtonPressed() {
        presenter?.cancelButtonPressed()
    }
    
    @objc
    func addButtonPressed() {
        presenter?.addButtonPressed()
    }
    
    @objc
    func eventDotPressed(_ sender: UITapGestureRecognizer) {
        guard let dotView = sender.view as? EventCircleImageView else { return }
        presenter?.eventDotPressed(type: dotView.eventType)
    }
}

// MARK: - UISearchBarDelegate

extension EventsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchTextChanged(text: searchText)
    }
}

// MARK: - DatesViewOutputting

extension EventsViewController: EventsViewOutputting {
    
    func configureNavigation(title: String) {
        navigationItem.title = title
    }
    
    func configureNavigation(state: EventsPresenter.NavigationState) {
        switch state {
        case .normal:
            navigationItem.titleView = nil
            navigationItem.rightBarButtonItems = [addButton, searchButton]
            
            UIView.animate(withDuration: 0.25, animations: {
                self.searchBar.frame = .zero
            }) { _ in
                self.searchBar.text = nil
            }
        case .search:
            navigationItem.titleView = searchBar
            navigationItem.rightBarButtonItems = [cancelButton]
            
            UIView.animate(withDuration: 0.25, animations: {
                self.searchBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.75, height: 44)
            }) { _ in
                self.searchBar.becomeFirstResponder()
            }
        }
    }
    
    func toggleDotFor(eventType: EventType, isSelected: Bool) {
        Dispatch.main {
            self.baseView.toggleDotFor(eventType: eventType, isSelected: isSelected)
        }
    }
    
    func toggleDotFor(noteType: NoteType, isSelected: Bool) {
        Dispatch.main {
            self.baseView.toggleDotFor(noteType: noteType, isSelected: isSelected)
        }
    }
    
    func hideNoteDots() {
        Dispatch.main {
            self.baseView.hideNoteDots()
        }
    }
    
    func showNoteDots() {
        Dispatch.main {
            self.baseView.showNoteDots()
        }
    }
    
    func populateView(activeEvents: [Event], activeNoteTypes: [NoteType]) {
        Dispatch.main {
            self.baseView.populate(
                with: EventsView.Content(
                    events: activeEvents,
                    noteTypes: activeNoteTypes
                )
            )
        }
    }
    
    func reloadView() {
        Dispatch.main {
            self.baseView.reloadData()
        }
    }
    
    func presentMailComposer(recipient: String, subject: String, body: String) {
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients([recipient])
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(body, isHTML: false)
            
            present(mailComposer, animated: true, completion: nil)
        } else {
            let emailString = "mailto:\(recipient)?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let emailURL = URL(string: emailString)!
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - EventsViewDelegate

extension EventsViewController: EventsViewDelegate {
    
    func didPressDot(eventType: EventType) {
        presenter?.eventDotPressed(type: eventType)
    }
    
    func didPressDot(noteType: NoteType) {
        presenter?.noteDotPressed(type: noteType)
    }
    
    func didSelectEvent(_ event: Event) {
        presenter?.selectEventPressed(event: event)
    }
    
    func didSelectNote(noteState: NoteState) {
        presenter?.selectNotePressed(noteState: noteState)
    }
    
    func presentAppReviewModal() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            } else {
                SKStoreReviewController.requestReview()
            }
        }
    }
}

// MARK: -

extension EventsViewController: MFMailComposeViewControllerDelegate {
 
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        controller.dismiss(animated: true, completion: nil)
    }
}
