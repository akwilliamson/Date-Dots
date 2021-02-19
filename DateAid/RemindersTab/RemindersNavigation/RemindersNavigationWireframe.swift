//
//  RemindersNavigationWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class RemindersNavigationWireframe {
    
    // MARK: Properties

    private var parentWireframe: TabBarWireframe?
    private let presenter = RemindersNavigationPresenter()
    
    // MARK: Initialization
    
    init(parentWireframe: TabBarWireframe) {
        self.parentWireframe = parentWireframe
        presenter.wireframe = self
        presenter.view = viewController()
    }
    
    // MARK: Routing
    
    func remindersNavigationView() -> UIViewController? {
        return presenter.view
    }
    
    func presentReminders(in navigation: RemindersNavigationViewController?) {
        let datesWireframe = RemindersWireframe(parentWireframe: self)
        datesWireframe.presentModule(in: navigation)
    }
    
    // MARK: Helpers
    
    private func viewController() -> RemindersNavigationViewController {
        let vc = RemindersNavigationViewController()
        vc.presenter = presenter
        return vc
    }
}
