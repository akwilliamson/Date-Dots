//
//  DatesNavigationPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/29/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class DatesNavigationPresenter {
    
    // MARK: Properties
    
    weak var wireframe: DatesNavigationWireframe?
    var view: DatesNavigationViewController?

    private enum Constant {
        enum Style {
            static let barTintColor = UIColor.navigationGray
            static let tintColor = UIColor.textGray
            static let foregroundColor = UIColor.textGray
            static let font = UIFont(name: "AvenirNext-Bold", size: 23)!
        }
    }
}

// MARK: DatesNavigationEventHandling

extension DatesNavigationPresenter: DatesNavigationEventHandling {
    
    func viewDidLoad() {
        view?.configureNavigation(barTintColor: Constant.Style.barTintColor, tintColor: Constant.Style.tintColor)
        view?.configureNavigation(titleTextAttributes: [
            NSAttributedString.Key.foregroundColor: Constant.Style.foregroundColor,
            NSAttributedString.Key.font: Constant.Style.font
        ])
    }

    func showDates(in navigation: DatesNavigationViewController?) {
        wireframe?.presentDates(in: navigation)
    }
}
