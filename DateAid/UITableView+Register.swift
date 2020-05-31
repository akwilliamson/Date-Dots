//
//  UITableView+Register.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/9/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

extension UITableView {

    func register(nib name: String?) {
        guard let name = name else { print("nib name doesn't exist"); return }
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
}
