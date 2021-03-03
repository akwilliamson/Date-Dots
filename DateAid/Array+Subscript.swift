//
//  Array+Subscript.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/1/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
