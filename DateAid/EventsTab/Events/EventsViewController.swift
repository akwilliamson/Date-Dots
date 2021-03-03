//
//  EventsViewController.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/8/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

protocol EventsViewOutputting: class {
 
    func configureNavigationBar(title: String)
    func configureTableView(footerView: UIView)

    func showSearchBar(frame: CGRect, duration: TimeInterval)
    func hideSearchBar(duration: TimeInterval)

    func updateDot(for eventType: EventType, isSelected: Bool)
    
    func reloadTableView(sections: IndexSet, animation: UITableView.RowAnimation)
    func deleteTableView(rows: [IndexPath], animation: UITableView.RowAnimation)
}

class EventsViewController: UIViewController {

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
        let dotView = IconCircleImageView(eventType: .birthday)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var anniversaryDot: IconCircleImageView = {
        let dotView = IconCircleImageView(eventType: .anniversary)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var holidayDot: IconCircleImageView = {
        let dotView = IconCircleImageView(eventType: .holiday)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var otherDot: IconCircleImageView = {
        let dotView = IconCircleImageView(eventType: .other)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
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

    var presenter: EventsEventHandling?

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        configureView()
        constructSubviews()
        constrainSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: View Setup

    private func configureView() {
        view.backgroundColor = .compatibleSystemBackground
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
            dotStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
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
        let eventSetupViewController = EventSetupViewController()
        navigationController?.pushViewController(eventSetupViewController, animated: true)
    }
    
    @objc
    func dotPressed(_ sender: UITapGestureRecognizer) {
        guard let dotView = sender.view as? IconCircleImageView else { return }
        presenter?.dotPressed(for: dotView.eventType)
    }
}

// MARK: - UITableViewDataSource

extension EventsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        let eventsToShow = presenter.eventsToShow()
        return eventsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let presenter = presenter,
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell
        else {
            return UITableViewCell()
        }

        let eventsToShow = presenter.eventsToShow()
        cell.event = eventsToShow[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? EventCell, let event = cell.event else { return }

        if editingStyle == .delete {
            presenter?.deleteEventPressed(for: event, at: indexPath)
        }
    }
}

// MARK: - UITableViewDelegate

extension EventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        let dotDates = presenter.eventsToShow()
        let event = dotDates[indexPath.row]
        let viewController = EventDetailsViewController(event: event)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension EventsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.textChanged(to: searchText)
    }
}

// MARK: - DatesViewOutputting

extension EventsViewController: EventsViewOutputting {
    
    // MARK: Configuration
    
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
    
    func updateDot(for eventType: EventType, isSelected: Bool) {
        switch eventType {
        case .birthday:    birthdayDot.setSelectedState(isSelected: isSelected)
        case .anniversary: anniversaryDot.setSelectedState(isSelected: isSelected)
        case .holiday:     holidayDot.setSelectedState(isSelected: isSelected)
        case .other:       otherDot.setSelectedState(isSelected: isSelected)
        }
    }
    
    func reloadTableView(sections: IndexSet, animation: UITableView.RowAnimation) {
        tableView.reloadSections(sections, with: animation)
        tableView.setContentOffset(.zero, animated: true)
    }
    
    func deleteTableView(rows: [IndexPath], animation: UITableView.RowAnimation) {
        tableView.deleteRows(at: rows, with: animation)
    }
}
