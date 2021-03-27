//
//  NotesWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NotesRouting: class {
    
    var navigation: UINavigationController? { get set }
    
    func present()
    
    func presentNoteDetails(noteState: NoteState)
    func dismissNoteDetails()
}

class NotesWireframe {
    
    // MARK: Wireframes
    
    private var parentWireframe: NotesNavigationWireframe
    private var childWireframe: NoteDetailsRouting?
    
    // MARK: Navigation
    
    var navigation: UINavigationController?
    
    private var view: UIViewController? {
        presenter.view as? UIViewController
    }
    
    // MARK: Presenter
    
    private var presenter: NotesPresenter
    
    // MARK: Initialization
    
    init(parentWireframe: NotesNavigationWireframe) {
        self.parentWireframe = parentWireframe
        
        let presenter = NotesPresenter()
        
        let view = NotesViewController()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = NotesInteractor()
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        self.presenter = presenter
        presenter.wireframe = self
    }

    func present() {
        guard let view = view else { return }

        navigation?.setViewControllers([view], animated: false)
    }
}

extension NotesWireframe: NotesRouting {
    
    func presentNoteDetails(noteState: NoteState) {
        let wireframe = NoteDetailsWireframe(parentWireframe: self, noteState: noteState)
        wireframe.navigation = navigation
        self.childWireframe = wireframe
        childWireframe?.present()
    }
    
    func dismissNoteDetails() {
        navigation?.dismiss(animated: true, completion: nil)
        self.childWireframe = nil
    }
}
