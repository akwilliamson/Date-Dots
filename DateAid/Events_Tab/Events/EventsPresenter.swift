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
    
    private var categorizedEvents: [EventType: [Date]] = [:]
    
    private var eventFilters: [EventType: Bool] = [
        .birthday:    false,
        .anniversary: false,
        .holiday:     false,
        .other:       false
    ]
    
    private var isSearching = false
    private var deleteIndex: IndexPath?
    private var deleteEventType: EventType?
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
    }
    
    func eventsToShow() -> [Date] {
        let birthdays     = shouldShowEvents(for: .birthday)    ? categorizedEvents[.birthday]    ?? [] : []
        let anniversaries = shouldShowEvents(for: .anniversary) ? categorizedEvents[.anniversary] ?? [] : []
        let holidays      = shouldShowEvents(for: .holiday)     ? categorizedEvents[.holiday]     ?? [] : []
        let other         = shouldShowEvents(for: .other)       ? categorizedEvents[.other]       ?? [] : []
        
        return birthdays + anniversaries + holidays + other
    }
    
    func searchButtonPressed() {
        isSearching = true
        view?.showSearchBar(frame: Constant.Layout.searchBarFrame, duration: Constant.Animation.searchBarDisplay)
    }

    func textChanged(to searchText: String) {}
    
    func cancelButtonPressed() {
        isSearching = false
        view?.hideSearchBar(duration: Constant.Animation.searchBarDisplay)
    }

    func dotPressed(for eventType: EventType) {
        let isSelected = !(eventFilters[eventType] ?? true)
        eventFilters[eventType] = isSelected
        view?.updateDot(for: eventType, isSelected: isSelected)
        view?.reloadTableView(sections: [0], animation: .fade)
    }
    
    func deleteEventPressed(for event: Date, at indexPath: IndexPath) {
        deleteIndex = indexPath
        deleteEventType = event.eventType
        interactor?.delete(event)
    }
    
    // MARK: Private Helpers
    
    private func shouldShowEvents(for eventType: EventType) -> Bool {
        return eventFilters[eventType] == true
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

        categorizedEvents[deleteEventType]?.removeAll(where: { $0.objectID == event.objectID })
        view?.deleteTableView(rows: [indexPath], animation: .automatic)
        deleteIndex = nil
    }
    
    func eventDeleteFailed(_ error: EventsInteractorError) {
        print(error.localizedDescription)
    }
}
