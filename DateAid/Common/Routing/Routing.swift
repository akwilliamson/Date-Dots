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
    /// The ability to dismiss a module.
    func dismiss(route: Route)
    /// The ability to dismiss a module with data.
    func dismiss<T>(route: Route, data: T?)
}

extension Routing {
    
    func present() { /* no-op */ }
    
    func dismiss(route: Route) { /* no-op */ }
    
    func dismiss<T>(route: Route, data: T?) { /* no-op */ }
}
