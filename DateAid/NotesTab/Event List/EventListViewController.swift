//
//  EventListViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventListViewOutputting {
    
    func setContent(_ content: EventListView.Content)
}

class EventListViewController: UIViewController {
    
    // MARK: UI
    
    private let baseView = EventListView()
    
    // MARK: Properties
    
    var presenter: EventListEventHandling?
    
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
    
    // MARK: Private Helpers
    
    private func configureView() {
        view.backgroundColor = .compatibleSystemBackground
        baseView.delegate = self
    }
}

// MARK: EventListViewOutputting

extension EventListViewController: EventListViewOutputting {
    
    func setContent(_ content: EventListView.Content) {
        baseView.populate(with: content)
    }
}

// MARK: EventListViewDelegate

extension EventListViewController: EventListViewDelegate {
    
    func didSelectEvent(_ event: Event) {
        presenter?.eventSelected(event)
    }
}
