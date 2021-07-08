//
//  EventsRouter.swift
//  Date Dots
//
//  Created by Aaron Williamson on 12/23/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

class EventsRouter {
    
    // MARK: Routing
    
    var parent: Routing?
    var child: Routing?
    
    // MARK: Presenter
    
    private var presenter: EventsPresenter
    
    // MARK: Initialization
    
    init(parent: Routing) {
        self.parent = parent
        
        let presenter = EventsPresenter()
        
        let view = EventsViewController()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = EventsInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        self.presenter = presenter
        presenter.router = self
    }
}

// MARK: - Routing

extension EventsRouter: Routing {
    
    // MARK: Self
    
    func present() {
        guard let view = presenter.view as? EventsViewController else { return }
        RouteManager.shared.navigationController?.setViewControllers([view], animated: false)
    }
    
    // MARK: Child routes
    
    func presentEventCreation() {
        child = RouteManager.shared.router(for: .eventCreation, parent: self)
        child?.present()
    }
    
    func presentEventDetails(event: Event) {
        child = RouteManager.shared.router(for: .eventDetails, parent: self, with: event)
        child?.present()
    }
    
    func presentEventNote(noteState: NoteState) {
        child = RouteManager.shared.router(for: .eventNoteDetails, parent: self, with: noteState)
        child?.present()
    }
    
    func dismiss<T>(route: Route, data: T?) {
        DispatchQueue.main.async {
            RouteManager.shared.navigationController?.popViewController(animated: true)
        }
        
        child = nil
    }
}
