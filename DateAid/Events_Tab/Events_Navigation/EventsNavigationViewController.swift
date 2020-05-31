//
//  DatesNavigationViewController.swift
//  Date Dots
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class EventsNavigationViewController: UINavigationController {
    
    // MARK: Properties
    
    var presenter: EventsNavigationEventHandling?
    
    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        presenter?.showEvents(in: self)
    }
}

// MARK: DatesNavigationViewOutputting

extension EventsNavigationViewController: EventsNavigationViewOutputting {

    func configureNavigation(barTintColor: UIColor, tintColor: UIColor) {
        navigationBar.barTintColor = barTintColor
        navigationBar.tintColor = tintColor
    }
    
    func configureNavigation(titleTextAttributes:  [NSAttributedString.Key : Any]?) {
        navigationBar.titleTextAttributes = titleTextAttributes
    }
}
