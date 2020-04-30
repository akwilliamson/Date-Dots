//
//  DatesWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 12/23/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

class DatesWireframe {
    
    private var presenter = DatesPresenter()
    private var parentWireframe: DatesNavigationWireframe?
    
    init(parentWireframe: DatesNavigationWireframe) {
        self.parentWireframe = parentWireframe
        presenter.wireframe = self
        presenter.view = viewController()
        presenter.interactor = datesInteractor()
    }

    func presentModule(in navigation: UINavigationController?) {
        guard let view = presenter.view as? DatesViewController else { return }
        navigation?.setViewControllers([view], animated: false)
    }
    
    private func viewController() -> DatesViewOutputting {
        let vc = DatesViewController()
        vc.presenter = presenter
        return vc
    }
    
    private func datesInteractor() -> DatesInteractorInputting {
        let di = DatesInteractor()
        di.presenter = presenter
        return di
    }
}
