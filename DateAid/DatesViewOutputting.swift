//
//  DatesViewProtocol.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

protocol DatesViewOutputting: class {
 
    func setNavigation(title: String)
    func setSegmentedControl(items: [String])
    func setSegmentedControl(selectedIndex: Int)
    func registerTableView(nib id: String)
    func setTableView(footerView: UIView)
    func setNavigation(titleView: UIView?)
    func setTabBarItemNamed(selectedName: String, unselectedName: String)
    
    func showSearchBar(frame: CGRect, duration: TimeInterval)
    func hideSearchBar(duration: TimeInterval)
    func reloadTableView(sections: IndexSet, animation: UITableViewRowAnimation)
    func deleteTableView(rows: [IndexPath], animation: UITableViewRowAnimation)
}
