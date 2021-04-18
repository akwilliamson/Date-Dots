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
    
    private var childImport: InitialImportWireframe?
    private var childEvents: EventsNavigationRouting?
    
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
        childImport = InitialImportWireframe()
        childImport?.presentModule(in: window)
    }
    
    func presentEventsModule(in window: UIWindow?) {
        childEvents = EventsNavigationWireframe(parent: self)
        childEvents?.display(in: window)
    }
}
