//
//  InitialImportWireframe.swift
//  Date Dots
//
//  Created by Aaron Williamson on 12/23/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

class InitialImportWireframe {
    
    var presenter = InitialImportPresenter()
    
    init() {
        presenter.wireframe = self
        presenter.view = initialImportViewController()
        presenter.interactor = initialImportInteractor()
    }
    
    func presentModule(in window: UIWindow?) {
        guard let view = presenter.view as? InitialImportViewController else { return }
        window?.rootViewController = view
    }
    
    func presentTabBar(in window: UIWindow?) {
        let tabBarWireframe = TabBarWireframe()
        tabBarWireframe.presentModule(in: window)
    }
    
    private func initialImportViewController<T: InitialImportViewController>() -> T {
        let vc: T = Constant.StoryboardId.main.vc(id: .initialImport)
        vc.presenter = presenter
        return vc
    }
    
    private func initialImportInteractor() -> InitialImportInteractor {
        let iii = InitialImportInteractor()
        iii.presenter = presenter
        return iii
    }
}
