//
//  UITableView+Register.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/9/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation

extension UITableView {

    func register(_ cell: String) {
        let nib = UINib(nibName: cell, bundle: nil)
        self.register(nib, forCellReuseIdentifier: cell)
    }

}
