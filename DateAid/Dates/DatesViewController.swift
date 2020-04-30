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
        stacKView.distribution = .fillEqually
        stacKView.spacing = 8
        return stacKView
    }()

    private lazy var birthdayDot: IconCircleImageView = {
        let dotView = IconCircleImageView(dateType: .birthday)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var anniversaryDot: IconCircleImageView = {
        let dotView = IconCircleImageView(dateType: .anniversary)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var holidayDot: IconCircleImageView = {
        let dotView = IconCircleImageView(dateType: .holiday)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var otherDot: IconCircleImageView = {
        let dotView = IconCircleImageView(dateType: .other)
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
        view.backgroundColor = .standardBackgroundColor
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
            dotStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dotStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dotStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            dotStackView.bottomAnchor.constraint(equalTo: tableView.topAnchor)
        ])
        NSLayoutConstraint.activate([
            birthdayDot.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5),
            birthdayDot.heightAnchor.constraint(equalTo: birthdayDot.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: dotStackView.bottomAnchor, constant: 20),
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
        guard let dotView = sender.view as? IconCircleImageView else { return }
        presenter?.dotPressed(for: dotView.dateType)
    }
}

// MARK: - UITableViewDataSource

extension DatesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        let dotDates = presenter.datesToShow()
        return dotDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let presenter = presenter,
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as? DateCell
        else {
            return UITableViewCell()
        }

        let dotDates = presenter.datesToShow()
        cell.date = dotDates[indexPath.row]

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
        guard let presenter = presenter else { return }
        let dotDates = presenter.datesToShow()
        let event = dotDates[indexPath.row]
        let viewController = DateDetailsViewController(event: event)
        navigationController?.pushViewController(viewController, animated: true)
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
    
    func configureTabBar(image: UIImage, selectedImage: UIImage) {
        tabBarItem = UITabBarItem(title: "Dates", image: image, selectedImage: selectedImage)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.textGray], for: .normal)
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
        case .birthday:    birthdayDot.updateImage(isSelected: isSelected)
        case .anniversary: anniversaryDot.updateImage(isSelected: isSelected)
        case .holiday:     holidayDot.updateImage(isSelected: isSelected)
        case .other:       otherDot.updateImage(isSelected: isSelected)
        }
    }
    
    func reloadTableView(sections: IndexSet, animation: UITableView.RowAnimation) {
        tableView.reloadSections(sections, with: animation)
    }
    
    func deleteTableView(rows: [IndexPath], animation: UITableView.RowAnimation) {
        tableView.deleteRows(at: rows, with: animation)
    }
}
