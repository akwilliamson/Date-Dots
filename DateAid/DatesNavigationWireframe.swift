//
//  DatesNavigationWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/29/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class DatesNavigationWireframe {

    private var parentWireframe: TabBarWireframe?
    
    private let presenter = DatesNavigationPresenter()
    
    init(parentWireframe: TabBarWireframe) {
        self.parentWireframe = parentWireframe
        presenter.wireframe = self
        presenter.view = viewController()
    }
    
    public func presentModule(in tabBar: TabBarViewController?) {
        guard let view = presenter.view as? DatesNavigationViewController else { return }
        tabBar?.viewControllers = [view]
    }
    
    public func presentDates(in navigation: DatesNavigationViewController?) {
        let datesWireframe = DatesWireframe(parentWireframe: self)
        datesWireframe.presentModule(in: navigation)
    }
    
    private func viewController() -> DatesNavigationViewOutputting {
        let vc = DatesNavigationViewController()
        vc.presenter = presenter
        return vc
    }
}
