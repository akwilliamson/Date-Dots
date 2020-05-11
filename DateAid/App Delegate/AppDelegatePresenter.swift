//
//  AppDelegatePresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/3/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class AppDelegatePresenter {
    
    weak var view: AppDelegateOutputting?
    weak var wireframe: AppDelegateWireframe?
    
    private enum Constant {
        static let tintColor = UIColor.compatibleLabel
        static let barTintColor = UIColor.compatibleSystemGray3
    }
}

extension AppDelegatePresenter: AppDelegateEventHandling {
    
    func setupApp() {
        view?.setTabBar(tintColor: Constant.tintColor)
        view?.setTabBar(barTintColor: Constant.barTintColor)
    }
    
    func showInitialImport(in window: UIWindow?) {
        wireframe?.presentInitialImportModule(in: window)
    }
    
    func showDatesTabBar(in window: UIWindow?) {
        wireframe?.presentNavigationModule(in: window)
    }
}
