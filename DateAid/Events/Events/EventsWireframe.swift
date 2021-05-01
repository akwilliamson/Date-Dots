//
//  EventsWireframe.swift
//  Date Dots
//
//  Created by Aaron Williamson on 12/23/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventsRouting: AnyObject {
    
    var navigation: UINavigationController? { get set }
    // Self
    func present()
    // Event Details
    func presentEventDetails(event: Event)
    func dismissEventDetails()
    // Note Details
    func presentEventNote(state: NoteState)
    func dismissEventNote()
}

class EventsWireframe {
    
    // MARK: Routers
    
    private let parent: EventsNavigationRouting
    private var childEventDetails: EventDetailsRouting?
    private var childEventNote: NoteDetailsRouting?
    
    // MARK: Navigation
    
    var navigation: UINavigationController?
    
    // MARK: Presenter
    
    private var presenter: EventsPresenter
    
    // MARK: Initialization
    
    init(parent: EventsNavigationRouting) {
        self.parent = parent
        
        let presenter = EventsPresenter()
        
        let view = EventsViewController()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = EventsInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        self.presenter = presenter
        presenter.wireframe = self
    }
}

// MARK: - EventsRouting

extension EventsWireframe: EventsRouting {
    
    // MARK: Self
    
    func present() {
        guard let view = presenter.view as? EventsViewController else { return }
        navigation?.setViewControllers([view], animated: false)
    }
    
    // MARK: Event Details
    
    func presentEventDetails(event: Event) {
        self.childEventDetails = EventDetailsWireframe(parent: self, event: event)
        childEventDetails?.navigation = navigation
        childEventDetails?.present()
    }
    
    func dismissEventDetails() {
        navigation?.popViewController(animated: true)
        childEventDetails = nil
    }
}

extension EventsWireframe: NoteDetailsParentRouting {
    
    func presentEventNote(state: NoteState) {
        self.childEventNote = NoteDetailsWireframe(parent: self, noteState: state)
        childEventNote?.navigation = navigation
        childEventNote?.present()
    }
    
    func dismissEventNote() {
        navigation?.popViewController(animated: true)
        childEventNote = nil
    }
}
