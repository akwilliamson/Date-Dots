//
//  Routing.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/1/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

// MARK: Routing

protocol Routing {
    /// The ability to present a module.
    func present()
}

extension Routing {
    
    func present() { /* no-op */ }
}
