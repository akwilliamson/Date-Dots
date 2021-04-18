//
//  DatesNavigationPresenter.swift
//  Date Dots
//
//  Created by Aaron Williamson on 1/29/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventsNavigationEventHandling: class {

    func viewDidLoad()
    func showEvents(in navigation: EventsNavigationViewController?)
}

class EventsNavigationPresenter {
    
    // MARK: Properties
    
    weak var wireframe: EventsNavigationWireframe?
    var view: EventsNavigationViewController?

    private enum Constant {
        enum Style {
            static let barTintColor = UIColor.compatibleSystemGray3
            static let tintColor = UIColor.compatibleLabel
            static let foregroundColor = UIColor.compatibleLabel
            static let font = FontType.avenirNextDemiBold(23).font
        }
    }
}

// MARK: EventsNavigationEventHandling

extension EventsNavigationPresenter: EventsNavigationEventHandling {
    
    func viewDidLoad() {
        view?.configureNavigation(barTintColor: Constant.Style.barTintColor, tintColor: Constant.Style.tintColor)
        view?.configureNavigation(titleTextAttributes: [
            NSAttributedString.Key.foregroundColor: Constant.Style.foregroundColor,
            NSAttributedString.Key.font: Constant.Style.font
        ])
    }

    func showEvents(in navigation: EventsNavigationViewController?) {
        wireframe?.displayEvents()
    }
}
