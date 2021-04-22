//
//  EventDetailsViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/14/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventDetailsViewOutputting: class {
    
    // Navigation View
    func configureNavigation(title: String)
    
    // Base View
    func setDetails(content: EventDetailsView.Content)

    // Actions
    func select(infoType: InfoType)
    func select(noteType: NoteType)
}

class EventDetailsViewController: UIViewController {
    
    // MARK: UI
    
    private var editButton: UIBarButtonItem {
        let button =  UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(editButtonPressed))
        return button
    }
    
    private let baseView = EventDetailsView()
    
    // MARK: Properties
    
    weak var presenter: EventDetailsEventHandling?
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        view = baseView
        baseView.delegate = self
        navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    // MARK: Actions
    
    @objc
    func editButtonPressed() {
        print("TODO: Route to edit event")
    }
}

// MARK: - EventDetailsViewOutputting

extension EventDetailsViewController: EventDetailsViewOutputting {
    
    // Navigation View
    
    func configureNavigation(title: String) {
        navigationItem.title = title
    }
    
    // Base View
    
    func setDetails(content: EventDetailsView.Content) {
        DispatchQueue.main.async {
            self.baseView.populate(with: content)
        }
    }
    
    // Actions
    
    func select(infoType: InfoType) {
        baseView.select(infoType: infoType)
    }
    
    func select(noteType: NoteType) {
        baseView.select(noteType: noteType)
    }
}

// MARK: - EventDetailsViewDelegate

extension EventDetailsViewController: EventDetailsViewDelegate {
    
    func didSelectInfoType(_ infoType: InfoType) {
        presenter?.didSelect(infoType: infoType)
    }
    
    func didSelectNoteType(_ noteType: NoteType) {
        presenter?.didSelect(noteType: noteType)
    }
}
