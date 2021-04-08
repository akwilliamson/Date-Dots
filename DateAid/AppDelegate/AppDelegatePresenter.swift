//
//  AppDelegatePresenter.swift
//  Date Dots
//
//  Created by Aaron Williamson on 2/3/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class AppDelegatePresenter {
    
    weak var wireframe: AppDelegateWireframe?
}

extension AppDelegatePresenter: AppDelegateEventHandling {
    
    func showImport(in window: UIWindow?) {
        wireframe?.presentImportModule(in: window)
    }
    
    func showEvents(in window: UIWindow?) {
        wireframe?.presentEventsModule(in: window)
    }
}
