//
//  DatesViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/8/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

protocol ReloadDatesTableDelegate {
    func reloadTableView()
}

class DatesViewController: UIViewController {

    var dataSource = DatesDataSource()
    var viewPresenter: DatesViewPresenter!
    
    var searching: Bool = false
    var searchButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.showSearch))
    }
    var cancelButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelSearch))
    }
    var addButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addDate))
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logEvents(forString: Event.dates.value)

        let dates = dataSource.fetch(dateType: nil)
        let searchBar = createSearchBar()
        
        viewPresenter = DatesViewPresenter(dates, searchBar: searchBar)
        
        formatView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewPresenter.searchBar.text = nil
        tableView.reloadData()
        
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItems = [addButton, searchButton]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueId.dateDetails.value {
            guard let dateDetailsVC = segue.destination as? DateDetailsViewController,
                let indexPath = tableView.indexPathForSelectedRow else {
                    return
            }
            dateDetailsVC.reloadDatesTableDelegate = self
            dateDetailsVC.dateObject = viewPresenter.date(for: indexPath)
        }
        
        if segue.identifier == SegueId.addDate.value {
            guard let addDateVC = segue.destination as? AddDateVC else {
                return
            }
            addDateVC.isBeingEdited = false
            addDateVC.dateType = "birthday"
            addDateVC.reloadDatesTableDelegate = self
        }
    }
    
    private func createSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        
        return searchBar
    }
    
    private func formatView() {
        title = Foundation.Date.today.formattedForTitle
        navigationItem.rightBarButtonItems = [addButton, searchButton]
        tableView.register(CellId.dateCell.value)
        tableView.tableFooterView = UIView()
    }
    
    func showSearch() {
        let width = view.frame.width * 0.75
        let height = navigationController?.navigationBar.frame.height
        viewPresenter.showSearch(size: CGSize(width: width, height: height!))
        navigationItem.titleView = viewPresenter.searchBar
        navigationItem.rightBarButtonItems = [addButton, cancelButton]
        viewPresenter.searchBar.becomeFirstResponder()
    }
    
    func cancelSearch() {
        viewPresenter.hideSearch()
        viewPresenter.searchBar.text = nil
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItems = [addButton, searchButton]
        tableView.reloadData()
    }
    
    func addDate() {
        self.performSegue(withIdentifier: SegueId.addDate.value, sender: self)
    }
}

extension DatesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewPresenter.dateCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellId.dateCell.value, for: indexPath) as? DateCell {
            cell.date = viewPresenter.date(for: indexPath)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let date = viewPresenter.popDate(at: indexPath) else { return }
            dataSource.delete(date)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension DatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: SegueId.dateDetails.value, sender: self)
    }
}

extension DatesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" { cancelSearch() }
        tableView.reloadData()
    }
}

extension DatesViewController: ReloadDatesTableDelegate {
    
    func reloadTableView() {
        tableView.reloadData()
    }
}
