//
//  ReminderRouter.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/20/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class ReminderRouter {
    
    // MARK: Wireframes
    
    var parent: Routing?
    
    // MARK: Presenter
    
    private var presenter: ReminderPresenter
    
    // MARK: Initialization
    
    init(parent: Routing, details: ReminderDetails) {
        self.parent = parent
        
        let presenter = ReminderPresenter(details: details)
        
        let view = ReminderViewController()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = ReminderInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        self.presenter = presenter
        presenter.router = self
    }
}

extension ReminderRouter: Routing {
    
    func present() {
        guard let view = presenter.view as? UIViewController else { return }
        RouteManager.shared.navigationController?.pushViewController(view, animated: true)
    }
    
    func dismiss() {
        parent?.dismiss()
    }
    
    func dismiss<T>(data: T) {
        parent?.dismiss(route: .eventReminder, data: data)
    }
}
