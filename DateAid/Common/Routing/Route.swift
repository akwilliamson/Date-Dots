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
    case eventCreation
    case eventDetails
    case eventEdit
    case eventNoteDetails
    case eventReminder
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
        case .eventCreation:
            return EventCreationRouter(parent: parent)
        default:
            return nil
        }
    }
    
    func router<T>(for route: Route, parent: Routing, with data: T) -> Routing? {
        switch route {
        case .eventDetails:
            guard let eventDetails = data as? EventDetails else { return nil }
            return EventDetailsRouter(parent: parent, eventDetails: eventDetails)
        case .eventCreation:
            guard let event = data as? Event else { return nil }
            return EventCreationRouter(parent: parent, event: event)
        case .eventNoteDetails:
            guard let noteState = data as? NoteState else { return nil }
            return NoteDetailsRouter(parent: parent, noteState: noteState)
        case .eventReminder:
            guard let details = data as? ReminderDetails else { return nil }
            return ReminderRouter(parent: parent, details: details)
        default:
            return nil
        }
    }
}
