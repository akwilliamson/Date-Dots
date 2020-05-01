//
//  TabBarPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class TabBarPresenter {
    
    // MARK: Properties
    
    weak var wireframe: TabBarWireframe?
    weak var view: TabBarViewController?
}

// MARK: TabBarEventHandling

extension TabBarPresenter: TabBarEventHandling {
    
    func showTabs(in tabBar: TabBarViewController) {
        wireframe?.presentDatesNavigation(in: tabBar)
    }
}
