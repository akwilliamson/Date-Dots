//
//  EventListPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

protocol EventListEventHandling: class {

    func viewDidLoad()
    func eventSelected(_ event: Event)
}

protocol EventListInteractorOutputting: class {
    
    func eventsFetched(_ events: [Event])
}

class EventListPresenter {
    
    // MARK: VIPER
    
    public var view: EventListViewOutputting?
    public var interactor: EventListInteractorInputting?
    public var wireframe: EventListRouting?
    
    // MARK: Constants

    private enum Constant {
        static let titleText = "Choose Event"
    }
}

// MARK: EventListEventHandling

extension EventListPresenter: EventListEventHandling {
    
    func viewDidLoad() {
        interactor?.fetchEvents()
    }
    
    func eventSelected(_ event: Event) {
        wireframe?.dismiss(event)
    }
}

// MARK: EventListInteractorOutputting

extension EventListPresenter: EventListInteractorOutputting {
    
    func eventsFetched(_ events: [Event]) {
        view?.setContent(
            EventListView.Content(
                title: Constant.titleText,
                events: events
            )
        )
    }
}
