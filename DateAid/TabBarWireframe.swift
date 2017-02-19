//
//  TabBarWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class TabBarWireframe: NSObject {
    
    let presenter = TabBarPresenter()
    
    var childDatesNavigationWireframe: DatesNavigationWireframe?
    
    override init() {
        super.init()
        presenter.wireframe = self
        presenter.view = tabBarViewController()
    }
    
    func presentModule(in window: UIWindow?) {
        guard let view = presenter.view as? TabBarViewController else { return }
        window?.rootViewController = view
    }
    
    func presentDatesNavigation(in tabBar: TabBarViewController?) {
        childDatesNavigationWireframe = DatesNavigationWireframe(parentWireframe: self)
        childDatesNavigationWireframe?.presentModule(in: tabBar)
    }
    
    private func tabBarViewController<T: TabBarViewController>() -> T {
        let vc: T = Constant.StoryboardId.main.vc(id: .tabBar)
        vc.presenter = presenter
        return vc
    }
}
