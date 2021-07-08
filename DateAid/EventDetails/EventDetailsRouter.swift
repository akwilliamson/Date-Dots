//
//  EventDetailsWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/14/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class EventDetailsRouter {
    
    // MARK: Routers
    
    var parent: Routing?
    var child: Routing?
    
    // MARK: Presenter
    
    private let presenter: EventDetailsPresenter
    
    // MARK: Initialization
    
    init(parent: Routing, event: Event) {
        self.parent = parent
        
        let presenter = EventDetailsPresenter(event: event)
        
        let view = EventDetailsViewController()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = EventDetailsInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        self.presenter = presenter
        presenter.router = self
    }
}

// MARK: - Routing

extension EventDetailsRouter: Routing {
    
    func present() {
        guard let view = presenter.view as? UIViewController else { return }
        RouteManager.shared.navigationController?.pushViewController(view, animated: true)
    }
    
    func presentEventCreation(event: Event) {
        child = RouteManager.shared.router(for: .eventCreation, parent: self, with: event)
        child?.present()
    }
    
    // TODO: Add dismiss edit event
    
    func presentEventReminder(details: ReminderDetails) {
        child = RouteManager.shared.router(for: .eventReminder, parent: self, with: details)
        child?.present()
    }
    
    // TODO: Add dismiss event reminder (with UNNotificationRequest)
    
    func presentEventNote(noteState: NoteState) {
        child = RouteManager.shared.router(for: .eventNoteDetails, parent: self, with: noteState)
        child?.present()
    }
    
    func dismiss<T>(route: Route, data: T) {
        switch route {
        case .eventCreation:
            guard let event = data as? Event else { return }
            presenter.handleUpdated(event: event)
        case .eventReminder:
            guard let notification = data as? UNNotificationRequest else { return }
            presenter.handleUpdated(notification: notification)
        default:
            break
        }
        
        DispatchQueue.main.async {
            RouteManager.shared.navigationController?.popViewController(animated: true)
        }
        child = nil
    }
}
