//
//  EventsNavigationRouter.swift
//  Date Dots
//
//  Created by Aaron Williamson on 1/29/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class EventsNavigationRouter {
    
    // MARK: Routing

    var parent: Routing?
    var child: Routing?
    
    // MARK: Presenter
    
    private let presenter: EventsNavigationPresenter
    
    // MARK: Initialization
    
    init(parent: Routing) {
        self.parent = parent
        
        let presenter = EventsNavigationPresenter()
        
        let view = EventsNavigationViewController()
        presenter.view = view
        view.presenter = presenter
        
        self.presenter = presenter
        presenter.router = self
    }
}

// MARK: - Navigation Routing

extension EventsNavigationRouter: Routing {
    
    func present() {
        guard
            let appDelegate = parent as? AppDelegate,
            let window = appDelegate.window
        else {
            return
        }
        RouteManager.shared.navigationController = presenter.view
        window.rootViewController = presenter.view
    }
    
    func presentEvents() {
        child = RouteManager.shared.router(for: .events, parent: self)
        child?.present()
    }
}
