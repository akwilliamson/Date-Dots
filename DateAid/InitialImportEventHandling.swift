//
//  InitialImportEventHandling.swift
//  DateAid
//
//  Created by Aaron Williamson on 12/23/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

protocol InitialImportEventHandling: class {
    
    func syncContactsPressed(in window: UIWindow?)
    func showTabBar(in window: UIWindow?)
}
