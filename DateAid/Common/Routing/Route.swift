//
//  Route.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/1/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

/// All available routes within the application.
enum Route {
    case eventsNavigation
    case events
    case eventDetails
    case eventEdit
    case eventReminder
    case eventNoteDetails
}

class RouteManager {
    
    // MARK: Static Instance
    
    static let shared = RouteManager()
    
    // MARK: Initialization
    
    private init() {}
    
    // MARK: Public Properties
    
    var navigationController: UINavigationController?
    
    // MARK: Public Methods
    
    func router(for route: Route, parent: Routing) -> Routing? {
        switch route {
        case .eventsNavigation:
            return EventsNavigationRouter(parent: parent)
        case .events:
            return EventsRouter(parent: parent)
        default:
            return nil
        }
    }
    
    func router<T>(for route: Route, parent: Routing, with data: T) -> Routing? {
        switch route {
        case .eventDetails:
            guard let event = data as? Event else { return nil }
            return EventDetailsRouter(parent: parent, event: event)
        case .eventNoteDetails:
            guard let noteState = data as? NoteState else { return nil }
            return NoteDetailsRouter(parent: parent, noteState: noteState)
        case .eventEdit:
            guard let _ = data as? Event else { return nil }
            // TODO: Return event edit router
            return nil
        case .eventReminder:
            guard let _ = data as? ReminderDetails else { return nil }
            // TODO: Return event reminder router
            return nil
        default:
            return nil
        }
    }
}
