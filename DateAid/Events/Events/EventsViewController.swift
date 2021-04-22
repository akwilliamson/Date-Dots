//
//  EventsViewController.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/8/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

protocol EventsViewOutputting: class {
 
    // Navigation View
    func configureNavigation(title: String)
    func configureNavigation(state: EventsPresenter.NavigationState)

    // Base View
    func toggleDotFor(eventType: EventType, isSelected: Bool)
    func toggleDotFor(noteType: NoteType, isSelected: Bool)
    
    func hideNoteDots()
    func showNoteDots()

    func reload(activeEvents: [Event], activeNoteTypes: [NoteType])
    func removeSectionFor(event: Event)
}

class EventsViewController: UIViewController {

    // MARK: UI

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: Actions
    
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
        print("TODO: Navigate to new event creation")
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
    
    // MARK: Configuration
    
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
        baseView.toggleDotFor(eventType: eventType, isSelected: isSelected)
    }
    
    func toggleDotFor(noteType: NoteType, isSelected: Bool) {
        baseView.toggleDotFor(noteType: noteType, isSelected: isSelected)
    }
    
    func hideNoteDots() {
        baseView.hideNoteDots()
    }
    
    func showNoteDots() {
        baseView.showNoteDots()
    }
    
    func reload(activeEvents: [Event], activeNoteTypes: [NoteType]) {
        baseView.populate(
            with: EventsView.Content(
                events: activeEvents,
                noteTypes: activeNoteTypes
            )
        )
        baseView.reloadData()
    }
    
    func removeSectionFor(event: Event) {
        baseView.deleteTableViewSectionFor(event: event)
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
    
    func didDeleteEvent(_ event: Event) {
        presenter?.deleteEventPressed(event: event)
    }
    
    func didSelectNote(_ note: Note) {
        print("TODO: navigate to selected note details")
    }
    
    func didDeleteNote(_ note: Note) {
        print("TODO: delete note and animate table view cell row deletion")
    }
}
