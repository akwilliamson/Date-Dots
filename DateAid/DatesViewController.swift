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

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()

    private var dotStackView: UIStackView = {
        let stacKView = UIStackView()
        stacKView.translatesAutoresizingMaskIntoConstraints = false
        stacKView.distribution = .equalSpacing
        return stacKView
    }()

    private lazy var birthdayDot: DateDotView = {
        let dotView = DateDotView(dateType: .birthday)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var anniversaryDot: DateDotView = {
        let dotView = DateDotView(dateType: .anniversary)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var holidayDot: DateDotView = {
        let dotView = DateDotView(dateType: .holiday)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var otherDot: DateDotView = {
        let dotView = DateDotView(dateType: .other)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DateCell.self, forCellReuseIdentifier: "DateCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var searchButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
    }
    
    private var cancelButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
    }
    
    private lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }()

    // MARK: Properties

    var presenter: DatesEventHandling?

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
        configureView()
        constructSubviews()
        constrainSubviews()
    }

    // MARK: View Setup

    private func configureView() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItems = [addButton, searchButton]
    }

    private func constructSubviews() {
        view.addSubview(dotStackView)
        dotStackView.addArrangedSubview(birthdayDot)
        dotStackView.addArrangedSubview(anniversaryDot)
        dotStackView.addArrangedSubview(holidayDot)
        dotStackView.addArrangedSubview(otherDot)
        view.addSubview(tableView)
    }

    private func constrainSubviews() {
        NSLayoutConstraint.activate([
            dotStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dotStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dotStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            dotStackView.bottomAnchor.constraint(equalTo: tableView.topAnchor)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: dotStackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: Actions
    
    @objc
    func searchButtonPressed() {
        presenter?.searchButtonPressed()
    }
    
    @objc
    func cancelButtonPressed() {
        presenter?.cancelButtonPressed()
    }
    
    @objc
    func addButtonPressed() {
        // present: AddDateVC()
        // set: addDateVC.isBeingEdited = false
        // set: addDateVC.dateType = "birthday"
    }
    
    @objc
    func dotPressed(_ sender: UITapGestureRecognizer) {
        guard let dotView = sender.view as? DateDotView else { return }
        presenter?.dotPressed(for: dotView.dateType)
    }
}

// MARK: - UITableViewDataSource

extension DatesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.dates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let presenter = presenter,
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as? DateCell
        else {
            return UITableViewCell()
        }

        cell.date = presenter.dates[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { presenter?.deleteDatePressed(at: indexPath) }
    }
}

// MARK: - UITableViewDelegate

extension DatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // present: DateDetailsViewController()
        // set: dateDetailsVC.dateObject = presenter?.dates[indexPath.row]
    }
}

// MARK: - UISearchBarDelegate

extension DatesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.textChanged(to: searchText)
    }
}

// MARK: - DatesViewOutputting

extension DatesViewController: DatesViewOutputting {
    
    // MARK: Configuration
    
    func configureTabBar(title: String, image: UIImage, selectedImage: UIImage) {
        tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
    }
    
    func configureNavigationBar(title: String) {
        navigationItem.title = title
    }
    
    func configureTableView(footerView: UIView) {
        tableView.tableFooterView = footerView
    }

    // MARK: Actions
    
    func showSearchBar(frame: CGRect, duration: TimeInterval) {
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItems = [cancelButton]
        
        UIView.animate(withDuration: duration, animations: { 
            self.searchBar.frame = frame
        }) { completed in
            self.searchBar.becomeFirstResponder()
        }
    }
    
    func hideSearchBar(duration: TimeInterval) {
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItems = [addButton, searchButton]
        
        UIView.animate(withDuration: duration, animations: { 
            self.searchBar.frame = .zero
        }) { completed in
            self.searchBar.text = nil
        }
    }
    
    func updateDot(for dateType: DateType, isSelected: Bool) {
        switch dateType {
        case .birthday:    birthdayDot.updateImage(isSelected)
        case .anniversary: anniversaryDot.updateImage(isSelected)
        case .holiday:     holidayDot.updateImage(isSelected)
        case .other:       otherDot.updateImage(isSelected)
        }
    }
    
    func reloadTableView(sections: IndexSet, animation: UITableView.RowAnimation) {
        tableView.reloadSections(sections, with: animation)
    }
    
    func deleteTableView(rows: [IndexPath], animation: UITableView.RowAnimation) {
        tableView.deleteRows(at: rows, with: animation)
    }
}
