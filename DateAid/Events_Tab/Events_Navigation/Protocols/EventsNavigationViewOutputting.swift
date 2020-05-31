//
//  DatesNavigationViewOutputting.swift
//  Date Dots
//
//  Created by Aaron Williamson on 4/18/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventsNavigationViewOutputting: class {

    func configureNavigation(barTintColor: UIColor, tintColor: UIColor)
    func configureNavigation(titleTextAttributes:  [NSAttributedString.Key : Any]?)
}
