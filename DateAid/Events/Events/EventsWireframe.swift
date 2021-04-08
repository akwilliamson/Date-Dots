//
//  EventsWireframe.swift
//  Date Dots
//
//  Created by Aaron Williamson on 12/23/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventsRouting: class {
    
    var navigation: UINavigationController? { get set }
    
    func present()
}

class EventsWireframe {
    
    // MARK: Routers
    
    private var parentRouter: EventsNavigationRouting?
    
    // MARK: Navigation
    
    var navigation: UINavigationController?
    
    // MARK: Presenter
    
    private var presenter: EventsPresenter
    
    init(parentRouter: EventsNavigationRouting) {
        self.parentRouter = parentRouter
        
        let presenter = EventsPresenter()
        
        let view = EventsViewController()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = EventsInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        self.presenter = presenter
        presenter.wireframe = self
    }
}

// MARK: - EventsRouting

extension EventsWireframe: EventsRouting {
    
    func present() {
        guard let view = presenter.view as? EventsViewController else { return }
        navigation?.setViewControllers([view], animated: false)
    }
}
