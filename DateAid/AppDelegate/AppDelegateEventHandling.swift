//
//  AppDelegateEventHandling.swift
//  Date Dots
//
//  Created by Aaron Williamson on 2/3/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

protocol AppDelegateEventHandling: AnyObject {

    func showImport(in window: UIWindow?)
    func showEvents(in window: UIWindow?)
}
