//
//  NoteDetailsRouter.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/3/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NoteDetailsParentRouting: AnyObject {
    
    func presentEventNote(state: NoteState)
    func dismissEventNote()
}

protocol NoteDetailsRouting: AnyObject {
    
    var navigation: UINavigationController? { get set }
    
    func present()
    func dismiss()
}

class NoteDetailsWireframe {
    
    // MARK: Wireframes
    
    private var parent: NoteDetailsParentRouting
    
    // MARK: Navigation
    
    var navigation: UINavigationController?
    
    private var view: UIViewController? {
        presenter.view as? UIViewController
    }
    
    // MARK: Presenter
    
    private var presenter: NoteDetailsPresenter
    
    // MARK: Initialization
    
    init(parent: NoteDetailsParentRouting, noteState: NoteState) {
        self.parent = parent
        
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
}

extension NoteDetailsWireframe: NoteDetailsRouting {

    func present() {
        guard let view = view else { return }

        navigation?.pushViewController(view, animated: true)
    }
    
    func dismiss() {
        parent.dismissEventNote()
    }
}
