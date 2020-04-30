//
//  TabBarEventHandling.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

protocol TabBarEventHandling: class {

    func setupView()
    func showTabs(in tabBar: TabBarViewController)
}
