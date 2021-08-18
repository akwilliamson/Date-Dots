//
//  EventCreationRouter.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/25/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class EventCreationRouter {
    
    // MARK: Routing
    
    weak var parent: Routing?
    
    // MARK: Presenter
    
    private let presenter: EventCreationPresenter
    
    // MARK: Initialization
    
    init(parent: Routing, event: Event? = nil) {
        self.parent = parent
        
        let presenter = EventCreationPresenter(event: event)
        
        let view = EventCreationViewController()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = EventCreationInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        self.presenter = presenter
        presenter.router = self
    }
}

// MARK: Routing

extension EventCreationRouter: Routing {
    
    // MARK: Self
    
    func present() {
        guard let view = presenter.view as? EventCreationViewController else { return }
        RouteManager.shared.navigationController?.pushViewController(view, animated: true)
    }
    
    func dismiss(event: Event?) {
        parent?.dismiss(route: .eventCreation, data: event)
    }
}
