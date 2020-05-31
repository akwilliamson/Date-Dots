//
//  TabBarWireframe.swift
//  Date Dots
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class TabBarWireframe: NSObject {
    
    // MARK: Properties
    
    private let presenter = TabBarPresenter()
    private var eventsNavigationWireframe: EventsNavigationWireframe?
    
    // MARK: Initialization
    
    override init() {
        super.init()
        presenter.wireframe = self
        presenter.view = tabBarViewController()
    }

    // MARK: Routing
    
    func presentModule(in window: UIWindow?) {
        guard let view = presenter.view else { return }
        window?.rootViewController = view
    }
    
    func presentDatesNavigation(in tabBar: TabBarViewController?) {
        eventsNavigationWireframe = EventsNavigationWireframe(parentWireframe: self)
        eventsNavigationWireframe?.presentModule(in: tabBar)
    }

    // MARK: Helpers
    
    private func tabBarViewController() -> TabBarViewController {
        return TabBarViewController(presenter: presenter)
    }
}
