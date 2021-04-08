//
//  DatesNavigationWireframe.swift
//  Date Dots
//
//  Created by Aaron Williamson on 1/29/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventsNavigationRouting: class {
    
    func present(in window: UIWindow?)
    func presentEvents()
}

class EventsNavigationWireframe {
    
    // MARK: Routers

    private var parentRouter: AppDelegateWireframe
    private var childRouter: EventsRouting?
    
    // MARK: Presenter
    
    private let presenter: EventsNavigationPresenter
    
    // MARK: Initialization
    
    init(parentRouter: AppDelegateWireframe) {
        self.parentRouter = parentRouter
        
        let presenter = EventsNavigationPresenter()
        
        let view = EventsNavigationViewController()
        presenter.view = view
        view.presenter = presenter
        
        self.presenter = presenter
        presenter.wireframe = self
    }
}

// MARK: - EventsNavigationRouting

extension EventsNavigationWireframe: EventsNavigationRouting {
    
    func present(in window: UIWindow?) {
        guard let view = presenter.view else { return }

        window?.rootViewController = view
    }
    
    func presentEvents() {
        let childRouter = EventsWireframe(parentRouter: self)
        self.childRouter = childRouter
        self.childRouter?.navigation = presenter.view
        self.childRouter?.present()
    }
}
