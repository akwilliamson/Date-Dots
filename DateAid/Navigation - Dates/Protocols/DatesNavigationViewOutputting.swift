//
//  DatesNavigationViewOutputting.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/18/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

protocol DatesNavigationViewOutputting: class {

    func configureNavigation(barTintColor: UIColor, tintColor: UIColor)
    func configureNavigation(titleTextAttributes:  [NSAttributedString.Key : Any]?)
}
