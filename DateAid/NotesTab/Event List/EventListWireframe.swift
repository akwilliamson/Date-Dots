//
//  EventListRouter.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventListRouting: class {
 
    func present(in parentView: UIViewController?)
    func dismiss(_ event: Event)
}

class EventListWireframe {
    
    private var parentWireframe: NoteDetailsRouting
    
    private var presenter: EventListPresenter
    
    private var view: UIViewController? {
        presenter.view as? UIViewController
    }
    
    init(parentWireframe: NoteDetailsRouting) {
        self.parentWireframe = parentWireframe
        
        let presenter = EventListPresenter()
        
        let view = EventListViewController()
        view.presenter = presenter
        presenter.view = view
        
        let interactor = EventListInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        self.presenter = presenter
        presenter.wireframe = self
    }
}

extension EventListWireframe: EventListRouting {
    
    func present(in parentView: UIViewController?) {
        guard let view = view else { return }
        parentView?.present(view, animated: true, completion: nil)
    }
    
    func dismiss(_ event: Event) {
        parentWireframe.dismissEventList(event)
    }
}
