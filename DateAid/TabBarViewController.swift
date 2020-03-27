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
        tabBarItem.setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary(attributes), for: .normal)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
