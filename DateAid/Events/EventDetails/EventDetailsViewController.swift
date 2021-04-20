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
    func setInitialSelected(infoType: InfoType)
    func selectDotFor(infoType: InfoType)
    func setDetailsFor(event: Event, daysBefore: Int?, timeOfDay: Date?)
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
    
    func configureNavigation(title: String) {
        navigationItem.title = title
    }
    
    func setDetailsFor(event: Event, daysBefore: Int?, timeOfDay: Date?) {
        DispatchQueue.main.async {
            self.baseView.populate(
                with: EventDetailsView.Content(
                    event: event,
                    daysBefore: EventReminderDaysBefore(rawValue: daysBefore ?? 999),
                    timeOfDay: timeOfDay
                )
            )
        }
    }
    
    func setInitialSelected(infoType: InfoType) {
        baseView.setInitialInfoType(infoType: infoType)
    }
    
    func selectDotFor(infoType: InfoType) {
        baseView.selectDotFor(infoType: infoType)
    }
}

// MARK: - EventDetailsViewDelegate

extension EventDetailsViewController: EventDetailsViewDelegate {
    
    func didSelectInfoType(_ infoType: InfoType) {
        presenter?.infoDotPressed(type: infoType)
    }
}
