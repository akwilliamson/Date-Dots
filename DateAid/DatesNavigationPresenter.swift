//
//  DatesNavigationPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/29/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import Foundation

class DatesNavigationPresenter {
    
    weak var wireframe: DatesNavigationWireframe?
    weak var view: DatesNavigationViewOutputting?
}

extension DatesNavigationPresenter: DatesNavigationEventHandling {

    func showDates(in navigation: DatesNavigationViewController?) {
        wireframe?.presentDates(in: navigation)
    }
}
