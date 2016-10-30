//
//  DatesViewPresenterProtocol.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

protocol DatesViewPresenterProtocol: class {
    
    func styleSegmentedControl()
    func toggleDisplay(for button: UIBarButtonItem, navigationItem: UINavigationItem)
    func updateView()
    func showDetails(for date: Date)
}
