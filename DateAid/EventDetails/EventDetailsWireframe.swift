//
//  EventDetailsWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/14/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventDetailsRouting: AnyObject {
    
    var navigation: UINavigationController? { get set }
    
    func present()
    func dismiss()
    // Edit Event
    func presentEditEvent(event: Event)
    func dismissEditEvent()
    // Reminder
    func presentReminder(details: ReminderDetails)
    func dismissReminder(request: UNNotificationRequest)
}

class EventDetailsWireframe {
    
    // MARK: Routers
    
    private let parent: EventsRouting
    /// private var childEventEdit
    /// private var childEventReminder
    private var childEventNote: NoteDetailsRouting?
    
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
    
    func presentEditEvent(event: Event) {}
    func dismissEditEvent() {}
    
    func presentReminder(details: ReminderDetails) {}
    func dismissReminder(request: UNNotificationRequest) {}
}

extension EventDetailsWireframe: NoteDetailsParentRouting {
    
    func presentEventNote(state: NoteState) {
        let wireframe = NoteDetailsWireframe(parent: self, noteState: state)
        wireframe.navigation = navigation
        self.childEventNote = wireframe
        childEventNote?.present()
    }
    
    func dismissEventNote() {
        childEventNote?.dismiss()
    }
}
