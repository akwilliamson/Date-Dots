//
//  DatesViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/8/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class DatesViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: DateSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: DatesEventHandling?
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    var searchButton: UIBarButtonItem {
        let action = #selector(pressedSearchButton(sender:))
        return UIBarButtonItem(barButtonSystemItem: .search, target: self, action: action)
    }
    
    var cancelButton: UIBarButtonItem {
        let action = #selector(pressedCancelButton(sender:))
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: action)
    }
    
    lazy var addButton: UIBarButtonItem = {
        let action = #selector(pressedAddButton(sender:))
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: action)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logEvents(forString: Event.dates.value)
        navigationItem.rightBarButtonItems = [addButton, searchButton]
        presenter?.setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationItem.rightBarButtonItems?[1] = searchButton
        presenter?.resetView()
    }
    
    func pressedSearchButton(sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItems?[1] = cancelButton
        presenter?.pressedSearchButton()
    }
    
    func pressedCancelButton(sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItems = [addButton, searchButton]
        presenter?.pressedCancelButton()
    }
    
    func pressedAddButton(sender: UIBarButtonItem) {
        // self.performSegue(withIdentifier: Id.Segue.addDate.value, sender: self)
    }
    
    @IBAction func segmentedControlPressed(_ sender: DateSegmentedControl) {
        presenter?.segmentedControl(indexSelected: sender.selectedIndex)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Why aren't you using a wireframe?" {
            guard let dateDetailsVC = segue.destination as? DateDetailsViewController,
                  let indexPath = tableView.indexPathForSelectedRow else {
                    return
            }
            dateDetailsVC.dateObject = presenter?.dates[indexPath.row]
        }
        
        if segue.identifier == "Why aren't you using a wireframe?" {
            guard let addDateVC = segue.destination as? AddDateVC else { return }
            addDateVC.isBeingEdited = false
            addDateVC.dateType = "birthday"
        }
    }
}

extension DatesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter?.isSearching ?? false {
            return presenter?.filteredDates.count ?? 0
        } else {
            return presenter?.dates.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellId = presenter?.cellId else { return UITableViewCell() }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? DateCell {
            if presenter?.isSearching ?? false {
                cell.date = presenter?.filteredDates[indexPath.row]
            } else {
                cell.date = presenter?.dates[indexPath.row]
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { presenter?.deleteDate(atIndexPath: indexPath) }
    }
}

extension DatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // performSegue(withIdentifier: Id.Segue.dateDetails.value, sender: self)
    }
}

extension DatesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.filterDatesFor(searchText: searchText)
    }
}

extension DatesViewController: DatesViewOutputting {
    
    func setNavigation(title: String) {
        self.navigationItem.title = title
    }
    
    func setNavigation(titleView: UIView?) {
        self.navigationItem.titleView = titleView
    }
    
    func setSegmentedControl(items: [String]) {
        segmentedControl.items = items
    }
    
    func setSegmentedControl(selectedIndex: Int) {
        segmentedControl.selectedIndex = selectedIndex
    }
    
    func registerTableView(nib id: String) {
        tableView.register(nib: id)
    }
    
    func setTableView(footerView: UIView) {
        tableView.tableFooterView = footerView
    }
    
    func setSegmentedControl(with categories: [String], selectedIndex: Int) {
        segmentedControl.items = categories
        segmentedControl.selectedIndex = selectedIndex
    }
    
    func setTabBarItemNamed(selectedName: String, unselectedName: String) {
        let unselectedImage = UIImage(named: unselectedName)
        let selectedImage = UIImage(named: selectedName)
        let tabBarItem = UITabBarItem(title: "Dates", image: unselectedImage, selectedImage: selectedImage)
        self.tabBarItem = tabBarItem
    }
    
    func showSearchBar(frame: CGRect, duration: TimeInterval) {
        self.navigationItem.titleView = searchBar
        
        UIView.animate(withDuration: duration, animations: { 
            self.searchBar.frame = frame
        }) { completed in
            self.searchBar.becomeFirstResponder()
        }
    }
    
    func hideSearchBar(duration: TimeInterval) {
        self.navigationItem.titleView = nil
        
        UIView.animate(withDuration: duration, animations: { 
            self.searchBar.frame = .zero
        }) { completed in
            self.searchBar.text = nil
        }
    }
    
    func reloadTableView(sections: IndexSet, animation: UITableViewRowAnimation) {
        tableView.reloadSections(sections, with: animation)
    }
    
    func deleteTableView(rows: [IndexPath], animation: UITableViewRowAnimation) {
        tableView.deleteRows(at: rows, with: animation)
    }
}
