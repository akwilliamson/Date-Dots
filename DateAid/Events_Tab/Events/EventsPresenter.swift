//
//  EventsPresenter.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

class EventsPresenter {

    // MARK: VIPER
    
    public var view: EventsViewOutputting?
    public var interactor: EventsInteractorInputting?
    public weak var wireframe: EventsWireframe?

    // MARK: Constants

    private enum Constant {
        enum String {
            static let title = "Dates"
        }
        enum Image {
            static let iconSelected = UIImage(named: "selected-calendar")!.withRenderingMode(.alwaysTemplate)
            static let iconUnselected =  UIImage(named: "unselected-calendar")!.withRenderingMode(.alwaysTemplate)
        }
        enum Layout {
            static let searchBarFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.75, height: 44)
        }
        enum Animation {
            static let searchBarDisplay = 0.25
        }
    }

    // MARK: Properties
    
    private let eventTypes: [EventType] = [.birthday, .anniversary, .holiday, .other]
    
    private var categorizedEvents: [EventType: [Date]] = [:]
    
    private var isSearching = false
    private var deleteIndex: IndexPath?
    private var deleteEventType: EventType?
    
    private let notificationManager = NotificationManager()
}

// MARK: - EventsEventHandling

extension EventsPresenter: EventsEventHandling {

    // MARK: Properties
    
    func viewLoaded() {
        view?.configureTabBar(image: Constant.Image.iconUnselected, selectedImage: Constant.Image.iconSelected)
        view?.configureNavigationBar(title: Constant.String.title)
        view?.configureTableView(footerView: UIView())
    }
    
    func viewWillAppear() {
        interactor?.fetchEvents()
        view?.hideSearchBar(duration: Constant.Animation.searchBarDisplay)
    }
    
    func eventsToShow() -> [Date] {
        var eventsToShow = [Date]()

        eventTypes.forEach { eventType in
            let eventsShouldShow = UserDefaults.standard.bool(forKey: eventType.rawValue)
            view?.updateDot(for: eventType, isSelected: eventsShouldShow)
            let events = eventsShouldShow ? categorizedEvents[eventType] ?? [] : []
            eventsToShow.append(contentsOf: events)
        }
        
        return eventsToShow
    }
    
    func searchButtonPressed() {
        isSearching = true
        view?.showSearchBar(frame: Constant.Layout.searchBarFrame, duration: Constant.Animation.searchBarDisplay)
    }

    func textChanged(to searchText: String) {
        interactor?.getEvents(containing: searchText)
    }
    
    func cancelButtonPressed() {
        isSearching = false
        interactor?.getEvents()
        view?.hideSearchBar(duration: Constant.Animation.searchBarDisplay)
    }

    func dotPressed(for eventType: EventType) {
        let currentState = UserDefaults.standard.bool(forKey: eventType.rawValue)
        UserDefaults.standard.set(!currentState, forKey: eventType.rawValue)
        view?.updateDot(for: eventType, isSelected: !currentState)
        view?.reloadTableView(sections: [0], animation: .fade)
    }
    
    func deleteEventPressed(for event: Date, at indexPath: IndexPath) {
        deleteIndex = indexPath
        deleteEventType = event.eventType
        interactor?.delete(event)
    }
}

// MARK: - EventsInteractorOutputting

extension EventsPresenter: EventsInteractorOutputting {
    
    func eventsFetched(_ events: [Date]) {
        categorizedEvents[.birthday]    = events.filter { $0.eventType == .birthday }
        categorizedEvents[.anniversary] = events.filter { $0.eventType == .anniversary }
        categorizedEvents[.holiday]     = events.filter { $0.eventType == .holiday }
        categorizedEvents[.other]       = events.filter { $0.eventType == .other }

        view?.reloadTableView(sections: [0], animation: .fade)
    }
    
    func eventsFetchedFailed(_ error: EventsInteractorError) {
        print(error.localizedDescription)
    }
    
    func eventDeleted(_ event: Date) {
        guard
            let indexPath = deleteIndex,
            let deleteEventType = deleteEventType
        else {
            return
        }
        
        notificationManager.cancelNotificationWith(identifier: event.objectIDString)

        categorizedEvents[deleteEventType]?.removeAll(where: { $0.objectID == event.objectID })
        view?.deleteTableView(rows: [indexPath], animation: .automatic)
        deleteIndex = nil
    }
    
    func eventDeleteFailed(_ error: EventsInteractorError) {
        print(error.localizedDescription)
    }
}
