//
//  DatesEventHandling.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

protocol DatesEventHandling: class {
    
    var dateCellID: String     { get }
    var selectedTabIndex: Int  { get }
    var dates: [Date?]         { get }
    var filteredDates: [Date?] { get }
    var isSearching: Bool      { get }
    
    func setupView()
    func pressedSearchButton()
    func pressedCancelButton()
    func filterDatesFor(searchText: String)
    func segmentedControl(indexSelected: Int)
    func deleteDate(atIndexPath indexPath: IndexPath)
    func resetView()
}
