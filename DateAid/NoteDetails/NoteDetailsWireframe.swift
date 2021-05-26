//
//  NoteDetailsRouter.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/3/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class NoteDetailsRouter {
    
    // MARK: Wireframes
    
    var parent: Routing?
    var child: Routing?
    
    // MARK: Presenter
    
    private var presenter: NoteDetailsPresenter
    
    // MARK: Initialization
    
    init(parent: Routing, noteState: NoteState) {
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
        presenter.router = self
    }
}

extension NoteDetailsRouter: Routing {

    func present() {
        guard let view = presenter.view as? UIViewController else { return }
        RouteManager.shared.navigationController?.pushViewController(view, animated: true)
    }
}
