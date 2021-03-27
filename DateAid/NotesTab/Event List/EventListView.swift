//
//  EventListView.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/27/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventListViewDelegate: AnyObject {
    
    func didSelectEvent(_ event: Event)
}

class EventListView: BaseView {
    
    // MARK: UI
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = FontType.avenirNextMedium(25).font
        label.textColor = UIColor.compatibleLabel
        return label
    }()
    
    private lazy var eventTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.register(EventListCell.self, forCellReuseIdentifier: "EventListCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: Properties
    
    weak var delegate: EventListViewDelegate?
    
    private var events: [Event] = []
    
    // MARK: Lifecycle
    
    override func constructSubviewHierarchy() {
        super.constructSubviewHierarchy()
        
        addSubview(titleLabel)
        addSubview(eventTableView)
    }
    
    override func constructLayout() {
        super.constructLayout()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            eventTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            eventTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            eventTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            eventTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension EventListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectEvent(events[indexPath.row])
    }
}

extension EventListView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventListCell") as? EventListCell,
            let event = events[safe: indexPath.row]
        else {
            return UITableViewCell()
        }
        
        cell.event = event
        
        return cell
    }
}

extension EventListView: Populatable {
    
    struct Content {
        let title: String
        let events: [Event]
    }
    
    func populate(with content: Content) {
        titleLabel.text = content.title
        events = content.events
        eventTableView.reloadData()
    }
}
