//
//  DatesNavigationEventHandling.swift
//  Date Dots
//
//  Created by Aaron Williamson on 1/29/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import Foundation

protocol EventsNavigationEventHandling: class {

    func viewDidLoad()
    func showEvents(in navigation: EventsNavigationViewController?)
}
