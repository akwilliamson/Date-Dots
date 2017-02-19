//
//  DatesNavigationViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class DatesNavigationViewController: UINavigationController {
    
    var presenter: DatesNavigationEventHandling?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = .birthday
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                             NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 23)!]
        presenter?.showDates(in: self)
    }
}

extension DatesNavigationViewController: DatesNavigationViewOutputting {}
