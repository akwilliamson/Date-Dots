//
//  AppDelegateWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/3/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class AppDelegateWireframe {
    
    var presenter = AppDelegatePresenter()
    
    let initialImportWireframe = InitialImportWireframe()
    let tabBarWireframe = TabBarWireframe()
    
    init(appDelegateOutputting: AppDelegateOutputting) {
        presenter.view = appDelegateOutputting
        presenter.wireframe = self
    }
    
    func presentInitialImportModule(in window: UIWindow?) {
        initialImportWireframe.presentModule(in: window)
    }
    
    func presentNavigationModule(in window: UIWindow?) {
        tabBarWireframe.presentModule(in: window)
    }
}
