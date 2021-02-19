//
//  NotesWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class NotesWireframe {
    
    private var presenter = NotesPresenter()
    private var parentWireframe: NotesNavigationWireframe?
    
    init(parentWireframe: NotesNavigationWireframe) {
        self.parentWireframe = parentWireframe
        presenter.wireframe = self
        presenter.view = viewController()
        presenter.interactor = NotesInteractor()
    }

    func presentModule(in navigation: UINavigationController?) {
        guard let view = presenter.view as? NotesViewController else { return }
        navigation?.setViewControllers([view], animated: false)
    }
    
    private func viewController() -> NotesViewOutputting {
        let vc = NotesViewController()
        vc.presenter = presenter
        return vc
    }
    
    private func notesInteractor() -> NotesInteractorInputting {
        let di = NotesInteractor()
        di.presenter = presenter
        return di
    }
}
