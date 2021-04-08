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
    func toggleDotFor(_ eventType: EventType, isSelected: Bool)
    func reload(events: [Event])
    func removeRowFor(event: Event)
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
//        let eventSetupViewController = EventSetupViewController()
//        navigationController?.pushViewController(eventSetupViewController, animated: true)
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
        case .initial:
            navigationItem.rightBarButtonItems = [addButton, searchButton]
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
    
    func toggleDotFor(_ eventType: EventType, isSelected: Bool) {
        baseView.toggleDot(for: eventType, isSelected: isSelected)
    }
    
    func reload(events: [Event]) {
        baseView.reloadTableView(events: events)
    }
    
    func removeRowFor(event: Event) {
        baseView.deleteTableViewRowFor(event: event)
    }
}

extension EventsViewController: EventsViewDelegate {
    
    func didPressDot(eventType: EventType) {
        presenter?.eventDotPressed(type: eventType)
    }
    
    func didPressDot(noteType: NoteType) {
        presenter?.noteDotPressed(type: noteType)
    }
    
    func didDeleteEvent(_ event: Event) {
        presenter?.deleteEventPressed(event: event)
    }
    
    func didSelectEvent(_ event: Event) {
        presenter?.selectEventPressed(event: event)
    }
}
