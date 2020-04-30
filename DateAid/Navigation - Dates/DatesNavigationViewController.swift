//
//  DatesNavigationViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class DatesNavigationViewController: UINavigationController {
    
    // MARK: Properties
    
    var presenter: DatesNavigationEventHandling?
    
    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        presenter?.showDates(in: self)
    }
}

// MARK: DatesNavigationViewOutputting

extension DatesNavigationViewController: DatesNavigationViewOutputting {

    func configureNavigation(barTintColor: UIColor, tintColor: UIColor) {
        navigationBar.barTintColor = barTintColor
        navigationBar.tintColor = tintColor
    }
    
    func configureNavigation(titleTextAttributes:  [NSAttributedString.Key : Any]?) {
        navigationBar.titleTextAttributes = titleTextAttributes
    }
}
