//
//  AppDelegateEventHandling.swift
//  Date Dots
//
//  Created by Aaron Williamson on 2/3/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

protocol AppDelegateEventHandling: class {

    func setupApp()
    func showInitialImport(in window: UIWindow?)
    func showDatesTabBar(in window: UIWindow?)
}
