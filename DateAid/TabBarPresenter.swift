//
//  TabBarPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class TabBarPresenter {
    
    weak var wireframe: TabBarWireframe?
    weak var view: TabBarViewOutputting?
}

extension TabBarPresenter: TabBarEventHandling {

    func setupView() {
        view?.setTabBar(barTintColor: .birthday)
        view?.setTabBar(tintColor: .white)
        view?.setTabBar(attributes: [convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white])
    }
    
    func showTabs(in tabBar: TabBarViewController) {
        wireframe?.presentDatesNavigation(in: tabBar)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
