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
    
    func didSelectEvent(_ event: Event)
    func didDeleteEvent(_ event: Event)
    
    func didSelectNote(_ note: Note)
    func didDeleteNote(_ note: Note)
}

class EventsView: BaseView {
    
    // MARK: Constants
    
    private enum Constant {
        static let rowHeight: CGFloat = 40
    }
    
    // MARK: UI
    
    private var eventDotStackView: UIStackView = {
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var anniversaryDot: EventCircleImageView = {
        let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
        let dotView = EventCircleImageView(eventType: .anniversary, scaledSize: size)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var holidayDot: EventCircleImageView = {
        let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
        let dotView = EventCircleImageView(eventType: .holiday, scaledSize: size)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var otherDot: EventCircleImageView = {
        let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
        let dotView = EventCircleImageView(eventType: .other, scaledSize: size)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NoteCell.self, forCellReuseIdentifier: "NoteCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var noteDotStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var giftsNoteDot: NoteCircleImageView = {
        let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
        let dotView = NoteCircleImageView(noteType: .gifts, scaledSize: size)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(noteDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var plansNoteDot: NoteCircleImageView = {
        let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
        let dotView = NoteCircleImageView(noteType: .plans, scaledSize: size)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(noteDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var otherNoteDot: NoteCircleImageView = {
        let size = CGSize(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
        let dotView = NoteCircleImageView(noteType: .other, scaledSize: size)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(noteDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()
    
    // MARK: Properties
    
    weak var delegate: EventsViewDelegate?
    
    private var activeEvents: [Event] = []
    private var activeNoteTypes: [NoteType] = []
    
    // MARK: View Setup
    
    override func configureView() {
        super.configureView()
        backgroundColor = .compatibleSystemBackground
    }
    
    override func constructSubviewHierarchy() {
        super.constructSubviewHierarchy()
        addSubview(tableView)
        addSubview(eventDotStackView)
        eventDotStackView.addArrangedSubview(birthdayDot)
        eventDotStackView.addArrangedSubview(anniversaryDot)
        eventDotStackView.addArrangedSubview(holidayDot)
        eventDotStackView.addArrangedSubview(otherDot)
        addSubview(noteDotStackView)
        noteDotStackView.addArrangedSubview(giftsNoteDot)
        noteDotStackView.addArrangedSubview(plansNoteDot)
        noteDotStackView.addArrangedSubview(otherNoteDot)
    }
    
    override func constructLayout() {
        super.constructLayout()
        NSLayoutConstraint.activate([
            eventDotStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            eventDotStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            eventDotStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            birthdayDot.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/6),
            birthdayDot.heightAnchor.constraint(equalTo: birthdayDot.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            noteDotStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noteDotStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            giftsNoteDot.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/6),
            giftsNoteDot.heightAnchor.constraint(equalTo: giftsNoteDot.widthAnchor)
        ])
    }
    
    // MARK: Interface
    
    func toggleDotFor(eventType: EventType, isSelected: Bool) {
        switch eventType {
        case .birthday:       birthdayDot.setSelectedState(isSelected: isSelected)
        case .anniversary: anniversaryDot.setSelectedState(isSelected: isSelected)
        case .holiday:         holidayDot.setSelectedState(isSelected: isSelected)
        case .other:             otherDot.setSelectedState(isSelected: isSelected)
        }
    }
    
    func toggleDotFor(noteType: NoteType, isSelected: Bool) {
        switch noteType {
        case .gifts: giftsNoteDot.setSelectedState(isSelected: isSelected)
        case .plans: plansNoteDot.setSelectedState(isSelected: isSelected)
        case .other: otherNoteDot.setSelectedState(isSelected: isSelected)
        }
    }
    
    func hideNoteDots() {
        noteDotStackView.isHidden = true
    }
    
    func showNoteDots() {
        noteDotStackView.isHidden = false
    }
    
    func deleteTableViewSectionFor(event: Event) {
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
    
    @objc
    func noteDotPressed(_ sender: UITapGestureRecognizer) {
        guard let dot = sender.view as? NoteCircleImageView else { return }
        delegate?.didPressDot(noteType: dot.noteType)
    }
}

// MARK: - UITableViewDataSource

extension EventsView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let beginSection = 1
        let finalSection = 1
        return beginSection + activeEvents.count + finalSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeNoteTypes.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == activeEvents.count + 1 {
            return UIScreen.main.bounds.width/9 + 60
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == activeEvents.count + 1 {
            let spacerView = UIView()
            spacerView.translatesAutoresizingMaskIntoConstraints = false
            return spacerView
        } else {
            guard let event = activeEvents[safe: section - 1] else { return nil }
            let header = EventSectionHeader(event: event)
            header.delegate = self
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        guard
            indexPath.section != 0,
            indexPath.section != activeEvents.count + 1,
            let noteCell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteCell
        else {
            return UITableViewCell()
        }
        
        if
            let eventNotes = activeEvents[safe: indexPath.section - 1]?.notes,
            !eventNotes.isEmpty,
            let noteType = activeNoteTypes[safe: indexPath.row],
            let noteToShow = eventNotes.filter({ $0.noteType == noteType }).first
        {
            noteCell.populate(NoteCell.Content(note: noteToShow, noteType: nil))
            return noteCell
        } else {
            let noteType = activeNoteTypes[indexPath.row]
            noteCell.populate(NoteCell.Content(note: nil, noteType: noteType))
            return noteCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0
        }
        return UITableView.automaticDimension
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

// MARK: - UITableViewDelegate

extension EventsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if
            let eventNotes = activeEvents[safe: indexPath.section - 1]?.notes,
            !eventNotes.isEmpty,
            let noteType = activeNoteTypes[safe: indexPath.row],
            let selectedNote = eventNotes.filter({ $0.noteType == noteType }).first
        {
            delegate?.didSelectNote(selectedNote)
        }
    }
}

// MARK: - EventSectionHeaderDelegate

extension EventsView: EventSectionHeaderDelegate {
    
    func didSelectSectionHeader(event: Event) {
        delegate?.didSelectEvent(event)
    }
}

// MARK: - Populatable

extension EventsView: Populatable {
    
    // MARK: Content
    
    struct Content {
        let events: [Event]
        let noteTypes: [NoteType]
    }
    
    func populate(with content: Content) {
        self.activeEvents = content.events
        self.activeNoteTypes = content.noteTypes
        tableView.reloadData()
    }
}
