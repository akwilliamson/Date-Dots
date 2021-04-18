//
//  EventDetailsPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/14/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

protocol EventDetailsEventHandling: class {
    
    func viewDidLoad()
    func viewWillAppear()
}

class EventDetailsPresenter {
    
    // MARK: VIPER
    
    var view: EventDetailsViewOutputting?
    weak var wireframe: EventDetailsWireframe?
    
    // MARK: Properties
    
    private var event: Event
    
    // MARK: Initialization
    
    init(event: Event) {
        self.event = event
    }
}

// MARK: - EventDetailsEventHandling

extension EventDetailsPresenter: EventDetailsEventHandling {
    
    func viewDidLoad() {
        let title = "\(event.abbreviatedName) \(event.eventType.emoji)"
        view?.configureNavigation(title: title)
    }
    
    func viewWillAppear() {
        view?.setDetailsFor(event: event)
    }
}
