//
//  DatesEventHandling.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

protocol DatesEventHandling: class {
    
    func viewLoaded()
    func datesToShow() -> [Date]
    func searchButtonPressed()
    func textChanged(to searchText: String)
    func cancelButtonPressed()

    func dotPressed(for dateType: DateType)
    func deleteDatePressed(at indexPath: IndexPath)
}
