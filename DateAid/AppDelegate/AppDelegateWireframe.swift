//
//  AppDelegateWireframe.swift
//  Date Dots
//
//  Created by Aaron Williamson on 2/3/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class AppDelegateWireframe {
    
    // MARK: Routers
    
    private var childImportRouter: InitialImportWireframe?
    private var childEventsRouter: EventsNavigationRouting?
    
    // MARK: Presenter
    
    var presenter: AppDelegatePresenter
    
    // MARK: Initialization
    
    init() {
        let presenter = AppDelegatePresenter()
        self.presenter = presenter
        presenter.wireframe = self
    }
}

// MARK: Routing

extension AppDelegateWireframe {
    
    func presentImportModule(in window: UIWindow?) {
        let childRouter = InitialImportWireframe()
        childImportRouter = childRouter
        childImportRouter?.presentModule(in: window)
    }
    
    func presentEventsModule(in window: UIWindow?) {
        let childRouter = EventsNavigationWireframe(parentRouter: self)
        childEventsRouter = childRouter
        childEventsRouter?.present(in: window)
    }
}
