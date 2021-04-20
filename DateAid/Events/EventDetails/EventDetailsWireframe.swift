//
//  EventDetailsWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/14/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventDetailsRouting: class {
    
    var navigation: UINavigationController? { get set }
    
    func present()
    func dismiss()
    // Event Edit
    func presentEventEdit(event: Event)
    func dismissEventEdit()
    // Event Reminder
    func presentEventReminder(details: EventReminderDetails)
    func dismissEventReminder(request: UNNotificationRequest)
    // Event Note
    func presentEventNote(state: NoteState)
    func dismissEventNote()
}

class EventDetailsWireframe {
    
    // MARK: Routers
    
    private let parent: EventsRouting
    /// private var childEventEdit
    /// private var childEventReminder
    /// private var childEventNote
    
    // MARK: Navigation
    
    var navigation: UINavigationController?
    
    // MARK: Presenter
    
    private let presenter: EventDetailsPresenter
    
    // MARK: Initialization
    
    init(parent: EventsRouting, event: Event) {
        self.parent = parent
        
        let presenter = EventDetailsPresenter(event: event)
        
        let view = EventDetailsViewController()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = EventDetailsInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        self.presenter = presenter
        presenter.wireframe = self
    }
}

// MARK: - EventDetailsRouting

extension EventDetailsWireframe: EventDetailsRouting {
    
    func present() {
        guard let view = presenter.view as? UIViewController else { return }
        navigation?.pushViewController(view, animated: true)
    }
    
    func dismiss() {
        parent.dismissEventDetails()
    }
    
    func presentEventEdit(event: Event) {}
    func dismissEventEdit() {}
    
    func presentEventReminder(details: EventReminderDetails) {}
    func dismissEventReminder(request: UNNotificationRequest) {}
    
    func presentEventNote(state: NoteState) {}
    func dismissEventNote() {}
}
