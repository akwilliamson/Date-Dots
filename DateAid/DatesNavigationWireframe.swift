//
//  DatesNavigationWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/29/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class DatesNavigationWireframe {
    
    let presenter = DatesNavigationPresenter()
    
    var parentWireframe: TabBarWireframe?
    
    init(parentWireframe: TabBarWireframe) {
        self.parentWireframe = parentWireframe
        presenter.wireframe = self
        presenter.view = datesNavigationViewController()
    }
    
    func presentModule(in tabBar: TabBarViewController?) {  
        guard let view = presenter.view as? DatesNavigationViewController else { return }
        tabBar?.viewControllers = [view]
    }
    
    func presentDates(in navigation: DatesNavigationViewController?) {
        let datesWireframe = DatesWireframe(parentWireframe: self)
        datesWireframe.presentModule(in: navigation)
    }
    
    private func datesNavigationViewController<T: DatesNavigationViewController>() -> T {
        let vc: T = Constant.StoryboardId.main.vc(id: .datesNavigation)
        vc.presenter = presenter
        return vc
    }
}
