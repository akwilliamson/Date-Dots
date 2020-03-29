//
//  DatesViewProtocol.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

protocol DatesViewOutputting: class {
 
    func setNavigation(title: String)

    func showSearchBar(frame: CGRect, duration: TimeInterval)
    func hideSearchBar(duration: TimeInterval)
    
    func setSegmentedControl(tabStrings: [String])
    func setSegmentedControl(selectedIndex: Int)

    func registerTableView(cellClass: AnyClass?, reuseIdentifier: String)
    func setupTableView(with footerView: UIView)

    func reloadTableView(sections: IndexSet, animation: UITableView.RowAnimation)
    func deleteTableView(rows: [IndexPath], animation: UITableView.RowAnimation)

    func setTabBarItemNamed(selectedName: String, unselectedName: String)
}
