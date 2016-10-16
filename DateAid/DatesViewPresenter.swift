//
//  DatesViewPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/15/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

struct DatesViewPresenter {
    
    var fetchedDates: [Date?]
    var searchBar: UISearchBar!
    
    init(_ dates: [Date?], searchBar: UISearchBar) {
        searchBar.tintColor = UIColor.birthday
        self.fetchedDates = dates
        self.searchBar = searchBar
    }
    
    var filteredDates: [Date?] {
        guard let searchText = searchBar.text else { return [] }
        
        return fetchedDates.filter { date in
            date?.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }
    
    var arrangedDates: [Date?] {
        var mutableDates = fetchedDates
        
        fetchedDates.forEach({
            guard let formattedDate = $0?.equalizedDate else { return }
            if formattedDate < Foundation.Date().formatted("MM/dd") { mutableDates.shift() }
        })
        
        return mutableDates
    }
    
    var dateCount: Int {
        return searchBar.text != "" ? filteredDates.count : fetchedDates.count
    }
    
    func date(for indexPath: IndexPath) -> Date {
        return searchBar.text != "" ? filteredDates[indexPath.row]! : arrangedDates[indexPath.row]!
    }
    
    func showSearch(size: CGSize) {
        searchBar.frame.size = CGSize.zero
        UIView.animate(withDuration: 0.2) {
            self.searchBar.frame.size = size
        }
    }
    
    func hideSearch() {
        UIView.animate(withDuration: 0.2) {
            self.searchBar.frame.size = CGSize.zero
        }
    }
    
    mutating func popDate(at indexPath: IndexPath) -> Date? {
        return fetchedDates.remove(at: indexPath.row)
    }
}
