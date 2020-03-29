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

    // MARK: UI

    private lazy var segmentedControl: DateSegmentedControl = {
        let segmentedControl = DateSegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .touchUpInside)
        return segmentedControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private var searchButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(pressedSearchButton))
    }
    
    private var cancelButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(pressedCancelButton))
    }
    
    private lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressedAddButton))
    }()

    // MARK: Properties

    var presenter: DatesEventHandling?

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
        configureView()
        constructViews()
        constrainViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationItem.rightBarButtonItems?[1] = searchButton
        presenter?.resetView()
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

    // MARK: View Setup

    private func configureView() {
        navigationItem.rightBarButtonItems = [addButton, searchButton]
    }

    private func constructViews() {
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
    }

    private func constrainViews() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: Actions
    
    @objc
    func pressedSearchButton() {
        navigationItem.rightBarButtonItems = [cancelButton]
        presenter?.pressedSearchButton()
    }
    
    @objc
    func pressedCancelButton() {
        navigationItem.rightBarButtonItems = [addButton, searchButton]
        presenter?.pressedCancelButton()
    }
    
    @objc
    func pressedAddButton() {
        print("Show adding a date here")
    }
    
    @objc
    func segmentedControlTapped(_ sender: DateSegmentedControl) {
        presenter?.segmentedControl(indexSelected: sender.selectedIndex)
    }
}

// MARK: - UITableViewDataSource

extension DatesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }

        return presenter.isSearching ? presenter.filteredDates.count : presenter.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let presenter = presenter,
            let cell = tableView.dequeueReusableCell(withIdentifier: presenter.dateCellID, for: indexPath) as? DateCell
        else {
            return UITableViewCell()
        }

        cell.date = presenter.isSearching ? presenter.filteredDates[indexPath.row] : presenter.dates[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { presenter?.deleteDate(atIndexPath: indexPath) }
    }
}

// MARK: - UITableViewDelegate

extension DatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Show date details here")
    }
}

// MARK: - UISearchBarDelegate

extension DatesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.filterDatesFor(searchText: searchText)
    }
}

// MARK: - DatesViewOutputting

extension DatesViewController: DatesViewOutputting {
    
    func setNavigation(title: String) {
        navigationItem.title = title
    }
    
    func setSegmentedControl(tabStrings: [String]) {
        segmentedControl.items = tabStrings
    }
    
    func setSegmentedControl(selectedIndex: Int) {
        segmentedControl.selectedIndex = selectedIndex
    }
    
    func registerTableView(cellClass: AnyClass?, reuseIdentifier: String) {
        tableView.register(cellClass, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func setupTableView(with footerView: UIView) {
        tableView.tableFooterView = footerView
    }
    
    func setSegmentedControl(with categories: [String], selectedIndex: Int) {
        segmentedControl.items = categories
        segmentedControl.selectedIndex = selectedIndex
    }
    
    func setTabBarItemNamed(selectedName: String, unselectedName: String) {
        let unselectedImage = UIImage(named: unselectedName)
        let selectedImage = UIImage(named: selectedName)
        tabBarItem = UITabBarItem(title: "Dates", image: unselectedImage, selectedImage: selectedImage)
    }
    
    func showSearchBar(frame: CGRect, duration: TimeInterval) {
        navigationItem.titleView = searchBar
        
        UIView.animate(withDuration: duration, animations: { 
            self.searchBar.frame = frame
        }) { completed in
            self.searchBar.becomeFirstResponder()
        }
    }
    
    func hideSearchBar(duration: TimeInterval) {
        navigationItem.titleView = nil
        
        UIView.animate(withDuration: duration, animations: { 
            self.searchBar.frame = .zero
        }) { completed in
            self.searchBar.text = nil
        }
    }
    
    func reloadTableView(sections: IndexSet, animation: UITableView.RowAnimation) {
        tableView.reloadSections(sections, with: animation)
    }
    
    func deleteTableView(rows: [IndexPath], animation: UITableView.RowAnimation) {
        tableView.deleteRows(at: rows, with: animation)
    }
}
