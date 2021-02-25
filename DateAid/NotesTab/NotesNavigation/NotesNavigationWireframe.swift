//
//  NotesNavigationWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class NotesNavigationWireframe {
    
    // MARK: Properties

    private var parentWireframe: TabBarWireframe?
    private let presenter = NotesNavigationPresenter()
    
    // MARK: Initialization
    
    init(parentWireframe: TabBarWireframe) {
        self.parentWireframe = parentWireframe
        presenter.wireframe = self
        presenter.view = viewController()
    }
    
    // MARK: Routing
    
    func notesNavigationView() -> UIViewController? {
        return presenter.view
    }
    
    func presentNotes() {
        let datesWireframe = NotesWireframe(parentWireframe: self)
        datesWireframe.presentModule(in: presenter.view)
    }
    
    // MARK: Helpers
    
    private func viewController() -> NotesNavigationViewController {
        let vc = NotesNavigationViewController()
        vc.presenter = presenter
        return vc
    }
}
