//
//  DatesNavigationWireframe.swift
//  Date Dots
//
//  Created by Aaron Williamson on 1/29/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventsNavigationRouting: class {
    
    func display(in window: UIWindow?)
    func displayEvents()
}

class EventsNavigationWireframe {
    
    // MARK: Routers

    private let parent: AppDelegateWireframe
    private var child: EventsRouting?
    
    // MARK: Presenter
    
    private let presenter: EventsNavigationPresenter
    
    // MARK: Initialization
    
    init(parent: AppDelegateWireframe) {
        self.parent = parent
        
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
    
    func display(in window: UIWindow?) {
        guard let view = presenter.view else { return }

        window?.rootViewController = view
    }
    
    func displayEvents() {
        self.child = EventsWireframe(parent: self)
        self.child?.navigation = presenter.view
        self.child?.present()
    }
}
