//
//  DatesWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 12/23/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

class DatesWireframe {
    
    var presenter = DatesPresenter()
    
    var parentWireframe: DatesNavigationWireframe?
    
    init(parentWireframe: DatesNavigationWireframe) {
        self.parentWireframe = parentWireframe
        presenter.wireframe = self
        presenter.view = datesViewController()
        presenter.interactor = datesInteractor()
    }

    func presentModule(in navigation: UINavigationController?) {
        guard let view = presenter.view as? DatesViewController else { return }
        navigation?.setViewControllers([view], animated: false)
    }
    
    private func datesViewController<T: DatesViewController>() -> T {
        let vc: T = Constant.StoryboardId.main.vc(id: .dates)
        vc.presenter = presenter
        return vc
    }
    
    private func datesInteractor() -> DatesInteractor {
        let di = DatesInteractor()
        di.presenter = presenter
        return di
    }
}
