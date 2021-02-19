//
//  DatesNavigationWireframe.swift
//  Date Dots
//
//  Created by Aaron Williamson on 1/29/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class EventsNavigationWireframe {
    
    // MARK: Properties

    private var parentWireframe: TabBarWireframe?
    private let presenter = EventsNavigationPresenter()
    
    // MARK: Initialization
    
    init(parentWireframe: TabBarWireframe) {
        self.parentWireframe = parentWireframe
        presenter.wireframe = self
        presenter.view = viewController()
    }
    
    // MARK: Routing
    
    func eventsNavigationView() -> UIViewController? {
        return presenter.view
    }
    
    func presentDates(in navigation: EventsNavigationViewController?) {
        let datesWireframe = EventsWireframe(parentWireframe: self)
        datesWireframe.presentModule(in: navigation)
    }
    
    // MARK: Helpers
    
    private func viewController() -> EventsNavigationViewController {
        let vc = EventsNavigationViewController()
        vc.presenter = presenter
        return vc
    }
}
