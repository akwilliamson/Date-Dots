//
//  TabBarViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    // MARK: Properties
    
    private let presenter: TabBarPresenter

    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(presenter: TabBarPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setupView()
        presenter.showTabs(in: self)
    }
}

// MARK: TabBarViewOutputting

extension TabBarViewController: TabBarViewOutputting {
    
    func setTabBar(barTintColor: UIColor) {
        tabBar.barTintColor = barTintColor
    }

    func setTabBar(tintColor: UIColor) {
        tabBar.tintColor = tintColor
    }
}
