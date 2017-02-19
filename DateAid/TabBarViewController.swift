//
//  TabBarViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var presenter: TabBarPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
        presenter?.showTabs(in: self)
    }
}

extension TabBarViewController: TabBarViewOutputting {
    
    func setTabBar(barTintColor: UIColor) {
        tabBar.barTintColor = barTintColor
    }

    func setTabBar(tintColor: UIColor) {
        tabBar.tintColor = tintColor
    }
    
    func setTabBar(attributes: [String: Any]?) {
        tabBarItem.setTitleTextAttributes(attributes, for: .normal)
    }
}
