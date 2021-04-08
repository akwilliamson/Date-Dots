//
//  EventsView.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/5/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventsViewDelegate: AnyObject {
    
    func didPressDot(eventType: EventType)
    func didPressDot(noteType: NoteType)
    
    func didDeleteEvent(_ event: Event)
    func didSelectEvent(_ event: Event)
}

class EventsView: BaseView {
    
    // MARK: Constants
    
    private enum Constant {
        static let rowHeight: CGFloat = 40
    }
    
    // MARK: UI
    
    private var dotStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()

    private lazy var birthdayDot: EventCircleImageView = {
        let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
        let dotView = EventCircleImageView(eventType: .birthday, scaledSize: size)
        dotView.isUserInteractionEnabled = true
        dotView.contentMode = .center
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var anniversaryDot: EventCircleImageView = {
        let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
        let dotView = EventCircleImageView(eventType: .anniversary, scaledSize: size)
        dotView.isUserInteractionEnabled = true
        dotView.contentMode = .center
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var holidayDot: EventCircleImageView = {
        let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
        let dotView = EventCircleImageView(eventType: .holiday, scaledSize: size)
        dotView.isUserInteractionEnabled = true
        dotView.contentMode = .center
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var otherDot: EventCircleImageView = {
        let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
        let dotView = EventCircleImageView(eventType: .other, scaledSize: size)
        dotView.isUserInteractionEnabled = true
        dotView.contentMode = .center
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: Properties
    
    weak var delegate: EventsViewDelegate?
    
    private var activeEvents: [Event] = []
    private var activeNotes: [NoteType] = []
    
    // MARK: View Setup
    
    override func configureView() {
        super.configureView()
        backgroundColor = .compatibleSystemBackground
    }
    
    override func constructSubviewHierarchy() {
        super.constructSubviewHierarchy()
        addSubview(dotStackView)
        dotStackView.addArrangedSubview(birthdayDot)
        dotStackView.addArrangedSubview(anniversaryDot)
        dotStackView.addArrangedSubview(holidayDot)
        dotStackView.addArrangedSubview(otherDot)
        addSubview(tableView)
    }
    
    override func constructLayout() {
        super.constructLayout()
        NSLayoutConstraint.activate([
            dotStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            dotStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dotStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            birthdayDot.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/6),
            birthdayDot.heightAnchor.constraint(equalTo: birthdayDot.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: dotStackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Public Methods
    
    func toggleDot(for eventType: EventType, isSelected: Bool) {
        switch eventType {
        case .birthday:    birthdayDot.setSelectedState(isSelected: isSelected)
        case .anniversary: anniversaryDot.setSelectedState(isSelected: isSelected)
        case .holiday:     holidayDot.setSelectedState(isSelected: isSelected)
        case .other:       otherDot.setSelectedState(isSelected: isSelected)
        }
    }
    
    func reloadTableView(events: [Event]) {
        self.activeEvents = events
        
        tableView.reloadData()
        tableView.setContentOffset(.zero, animated: true)
    }
    
    func deleteTableViewRowFor(event: Event) {
        guard let index = activeEvents.firstIndex(where: { $0 == event }) else { return }
        let indexPath = IndexPath(index: index)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: Actions
    
    @objc
    func eventDotPressed(_ sender: UITapGestureRecognizer) {
        guard let dot = sender.view as? EventCircleImageView else { return }
        delegate?.didPressDot(eventType: dot.eventType)
    }
}

extension EventsView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        activeEvents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let eventNotes = activeEvents[safe: section]?.notes else { return 0 }

        return Array(Set(eventNotes.map { $0.noteType }).intersection(Set(activeNotes))).count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let event = activeEvents[safe: section] else { return nil }
        
        return EventSectionHeader(event: event)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _ = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell
        else {
            return UITableViewCell()
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.rowHeight
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        guard
//            let cell = tableView.cellForRow(at: indexPath) as? EventCell,
//            let event = cell.note
//        else {
//            return
//        }
//
//        if editingStyle == .delete {
//            delegate?.didDeleteEvent(event)
//        }
    }
}

extension EventsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = activeEvents[safe: indexPath.section] else { return }
        delegate?.didSelectEvent(event)
    }
}

extension EventsView: Populatable {
    
    // MARK: Content
    
    struct Content {
        let events: [Event]
        let noteTypes: [NoteType]
    }
    
    func populate(with content: Content) {
        self.activeEvents = content.events
        self.activeNotes = content.noteTypes
        tableView.reloadData()
    }
}
