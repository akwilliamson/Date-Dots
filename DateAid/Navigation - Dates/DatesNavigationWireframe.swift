//
//  DatesNavigationWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/29/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class DatesNavigationWireframe {
    
    // MARK: Properties

    private var parentWireframe: TabBarWireframe?
    private let presenter = DatesNavigationPresenter()
    
    // MARK: Initialization
    
    init(parentWireframe: TabBarWireframe) {
        self.parentWireframe = parentWireframe
        presenter.wireframe = self
        presenter.view = viewController()
    }
    
    // MARK: Routing
    
    func presentModule(in tabBar: TabBarViewController?) {
        guard let view = presenter.view else { return }
        tabBar?.viewControllers = [view]
    }
    
    func presentDates(in navigation: DatesNavigationViewController?) {
        let datesWireframe = DatesWireframe(parentWireframe: self)
        datesWireframe.presentModule(in: navigation)
    }
    
    // MARK: Helpers
    
    private func viewController() -> DatesNavigationViewController {
        let vc = DatesNavigationViewController()
        vc.presenter = presenter
        return vc
    }
}
