//
//  DispatchQueue+Helpers.swift
//  DateAid
//
//  Created by Aaron Williamson on 8/6/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

typealias Dispatch = DispatchQueue

extension Dispatch {

    static func background(_ task: @escaping () -> ()) {
        Dispatch.global(qos: .background).async {
            task()
        }
    }

    static func main(_ task: @escaping () -> ()) {
        Dispatch.main.async {
            task()
        }
    }
}
