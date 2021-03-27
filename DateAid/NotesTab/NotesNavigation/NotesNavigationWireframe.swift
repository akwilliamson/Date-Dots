//
//  NotesNavigationWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class NotesNavigationWireframe {
    
    // MARK: Wireframes

    private var parentWireframe: TabBarWireframe?
    private var childWireframe: NotesRouting?
    
    // MARK: Navigation
    
    var navigation: UINavigationController? {
        return presenter.view
    }
    
    // MARK: Presenter
    
    private let presenter = NotesNavigationPresenter()
    
    // MARK: Initialization
    
    init(parentWireframe: TabBarWireframe) {
        self.parentWireframe = parentWireframe
        presenter.wireframe = self
        presenter.view = viewController()
    }
    
    // MARK: Routing
    
    func presentNotes() {
        let notesWireframe = NotesWireframe(parentWireframe: self)
        notesWireframe.navigation = navigation
        notesWireframe.present()
    }
    
    // MARK: Helpers
    
    private func viewController() -> NotesNavigationViewController {
        let vc = NotesNavigationViewController()
        vc.presenter = presenter
        return vc
    }
}
