//
//  DatesViewProtocol.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

protocol DatesViewProtocol: class {
 
    func setSegmentedControl(_ items: [String], font: UIFont, selectedIndex: Int)
    func display(_ dates: [Date?])
    func displayNoDates()
}
