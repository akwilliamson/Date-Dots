//
//  EventDetailsWireframe.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/14/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class EventDetailsRouter {
    
    // MARK: Routers
    
    weak var parent: Routing?
    var child: Routing?
    
    // MARK: Presenter
    
    private let presenter: EventDetailsPresenter
    
    // MARK: Initialization
    
    init(parent: Routing, eventDetails: EventDetails) {
        self.parent = parent
        
        let presenter = EventDetailsPresenter(eventDetails: eventDetails)
        
        let view = EventDetailsViewController()
        presenter.view = view
        view.presenter = presenter
        
        let interactor = EventDetailsInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        self.presenter = presenter
        presenter.router = self
    }
}

// MARK: - Routing

extension EventDetailsRouter: Routing {
    
    func present() {
        guard let view = presenter.view as? UIViewController else { return }
        RouteManager.shared.navigationController?.pushViewController(view, animated: true)
    }
    
    func presentEventCreation(event: Event) {
        child = RouteManager.shared.router(for: .eventCreation, parent: self, with: event)
        child?.present()
    }
    
    func presentEventReminder(details: ReminderDetails) {
        child = RouteManager.shared.router(for: .eventReminder, parent: self, with: details)
        child?.present()
    }
    
    func presentEventNote(noteState: NoteState) {
        child = RouteManager.shared.router(for: .eventNoteDetails, parent: self, with: noteState)
        child?.present()
    }
    
    func dismiss<T>(route: Route, data: T) {
        switch route {
        case .eventCreation:
            if let event = data as? Event {
                presenter.handleUpdated(event: event)
                Dispatch.main {
                    RouteManager.shared.navigationController?.popViewController(animated: true)
                }
            } else {
                Dispatch.main {
                    RouteManager.shared.navigationController?.popToRootViewController(animated: true)
                }
            }
        case .eventNoteDetails:
            if let event = data as? Event {
                presenter.handleUpdated(event: event)
            }
            Dispatch.main {
                RouteManager.shared.navigationController?.popViewController(animated: true)
            }
        default:
            break
        }
        
        child = nil
    }
    
    func dismiss(route: Route) {
        switch route {
        case .eventReminder:
            Dispatch.main {
                RouteManager.shared.navigationController?.popViewController(animated: true)
            }
        default:
            break
        }
        child = nil
    }
}
