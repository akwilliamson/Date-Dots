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
    var selectedIndex: Int = 0
    
    init(_ dates: [Date?], searchBar: UISearchBar) {
        searchBar.tintColor = UIColor.birthday
        self.fetchedDates = dates
        self.searchBar = searchBar
    }
    
    var filteredDates: [Date?] {
        
        let searchText: String? = searchBar.text != "" ? searchBar.text : nil
        
        if selectedIndex == 0 {
            return arrangedDates.filter { date in
                guard let searchText = searchText else { return true }
                guard let containsName = date?.name?.lowercased().contains(searchText.lowercased()) else { return false }
                return containsName
            }
        } else {
            guard let dateType = FilterDateType(rawValue: selectedIndex)?.value else { return [] }
            
            return arrangedDates.filter { date in
                guard let containsType = date?.type?.contains(dateType) else { return false }
                guard let searchText = searchText else { return containsType }
                guard let containsName = date?.name?.lowercased().contains(searchText.lowercased()) else { return false }
                
                return containsType && containsName
            }
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
        return filteredDates.count
    }
    
    func date(for indexPath: IndexPath) -> Date {
        return filteredDates[indexPath.row]!
    }
    
    func dates(for type: String) -> [Date?] {
        return arrangedDates.filter { date in
            date?.type?.lowercased().contains(type.lowercased()) ?? false
        }
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
