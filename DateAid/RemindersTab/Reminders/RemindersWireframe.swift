//
//  RemindersWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class RemindersWireframe {
    
    private var presenter = RemindersPresenter()
    private var parentWireframe: RemindersNavigationWireframe?
    
    init(parentWireframe: RemindersNavigationWireframe) {
        self.parentWireframe = parentWireframe
        presenter.wireframe = self
        presenter.view = viewController()
        presenter.interactor = RemindersInteractor()
    }

    func presentModule(in navigation: UINavigationController?) {
        guard let view = presenter.view as? RemindersViewController else { return }
        navigation?.setViewControllers([view], animated: false)
    }
    
    private func viewController() -> RemindersViewOutputting {
        let vc = RemindersViewController()
        vc.presenter = presenter
        return vc
    }
    
    private func remindersInteractor() -> RemindersInteractorInputting {
        let di = RemindersInteractor()
        di.presenter = presenter
        return di
    }
}
