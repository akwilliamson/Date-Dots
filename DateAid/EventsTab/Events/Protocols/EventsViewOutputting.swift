//
//  EventsViewProtocol.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventsViewOutputting: class {
 
    func configureNavigationBar(title: String)
    func configureTableView(footerView: UIView)

    func showSearchBar(frame: CGRect, duration: TimeInterval)
    func hideSearchBar(duration: TimeInterval)

    func updateDot(for eventType: EventType, isSelected: Bool)
    
    func reloadTableView(sections: IndexSet, animation: UITableView.RowAnimation)
    func deleteTableView(rows: [IndexPath], animation: UITableView.RowAnimation)
}
