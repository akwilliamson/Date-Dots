//
//  DatesNavigationEventHandling.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/29/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import Foundation

protocol DatesNavigationEventHandling: class {

    func viewDidLoad()
    func showDates(in navigation: DatesNavigationViewController?)
}
