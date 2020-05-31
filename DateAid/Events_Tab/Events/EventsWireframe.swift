//
//  EventsWireframe.swift
//  Date Dots
//
//  Created by Aaron Williamson on 12/23/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

class EventsWireframe {
    
    private var presenter = EventsPresenter()
    private var parentWireframe: EventsNavigationWireframe?
    
    init(parentWireframe: EventsNavigationWireframe) {
        self.parentWireframe = parentWireframe
        presenter.wireframe = self
        presenter.view = viewController()
        presenter.interactor = eventsInteractor()
    }

    func presentModule(in navigation: UINavigationController?) {
        guard let view = presenter.view as? EventsViewController else { return }
        navigation?.setViewControllers([view], animated: false)
    }
    
    private func viewController() -> EventsViewOutputting {
        let vc = EventsViewController()
        vc.presenter = presenter
        return vc
    }
    
    private func eventsInteractor() -> EventsInteractorInputting {
        let di = EventsInteractor()
        di.presenter = presenter
        return di
    }
}
