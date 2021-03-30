//
//  NoteDetailsRouter.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/3/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NoteDetailsRouting: class {
    
    var navigation: UINavigationController? { get set }
    
    func present()
    func dismiss()
    // Event List
    func presentEventList()
    func dismissEventList(_ event: Event)
    // Event Details
    func pushEventDetails(_ event: Event)
}

class NoteDetailsWireframe {
    
    // MARK: Wireframes
    
    private var parentWireframe: NotesRouting
    private var childWireframe: EventListRouting?
    
    // MARK: Navigation
    
    var navigation: UINavigationController?
    
    private var view: UIViewController? {
        presenter.view as? UIViewController
    }
    
    // MARK: Presenter
    
    private var presenter: NoteDetailsPresenter
    
    // MARK: Initialization
    
    init(parentWireframe: NotesWireframe, noteState: NoteState) {
        self.parentWireframe = parentWireframe
        
        let presenter = NoteDetailsPresenter()
        presenter.noteState = noteState
        
        let view = NoteDetailsViewController()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = NoteDetailsInteractor()
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        self.presenter = presenter
        presenter.wireframe = self
    }
    
    func present() {
        guard let view = view else { return }

        navigation?.pushViewController(view, animated: true)
    }
    
    func dismiss() {
        parentWireframe.dismissNoteDetails()
    }
}

extension NoteDetailsWireframe: NoteDetailsRouting {
    
    func presentEventList() {
        guard let view = view else { return }
        
        self.childWireframe = EventListWireframe(parentWireframe: self)
        childWireframe?.present(in: view)
    }
    
    func dismissEventList(_ event: Event) {
        presenter.didChooseEvent(event)
        navigation?.dismiss(animated: true, completion: nil)
    }
    
    func pushEventDetails(_ event: Event) {
        let eventDetailsViewController = EventDetailsViewController(event: event)
        navigation?.pushViewController(eventDetailsViewController, animated: true)
    }
}
