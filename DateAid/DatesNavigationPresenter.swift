//
//  DatesNavigationPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/29/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import Foundation

class DatesNavigationPresenter {
    
    public weak var wireframe: DatesNavigationWireframe?
    public var view: DatesNavigationViewOutputting?
}

extension DatesNavigationPresenter: DatesNavigationEventHandling {

    public func showDates(in navigation: DatesNavigationViewController?) {
        wireframe?.presentDates(in: navigation)
    }
}
