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
}

extension AppDelegatePresenter: AppDelegateEventHandling {
    
    func setupApp() {}
    
    func showInitialImport(in window: UIWindow?) {
        wireframe?.presentInitialImportModule(in: window)
    }
    
    func showDatesTabBar(in window: UIWindow?) {
        wireframe?.presentNavigationModule(in: window)
    }
}
