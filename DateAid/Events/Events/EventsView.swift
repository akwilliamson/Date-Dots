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
    
    func didSelectNote(noteState: NoteState)
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
        let dotView = EventCircleImageView(eventType: .birthday)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        
        dotView.layer.shadowColor = UIColor.black.cgColor
        dotView.layer.shadowRadius = 10.0
        dotView.layer.shadowOpacity = 1.0
        dotView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return dotView
    }()

    private lazy var anniversaryDot: EventCircleImageView = {
        let dotView = EventCircleImageView(eventType: .anniversary)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        
        dotView.layer.shadowColor = UIColor.black.cgColor
        dotView.layer.shadowRadius = 10.0
        dotView.layer.shadowOpacity = 1.0
        dotView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return dotView
    }()

    private lazy var customDot: EventCircleImageView = {
        let dotView = EventCircleImageView(eventType: .custom)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        
        dotView.layer.shadowColor = UIColor.black.cgColor
        dotView.layer.shadowRadius = 10.0
        dotView.layer.shadowOpacity = 1.0
        dotView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return dotView
    }()

    private lazy var otherDot: EventCircleImageView = {
        let dotView = EventCircleImageView(eventType: .other)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        
        dotView.layer.shadowColor = UIColor.black.cgColor
        dotView.layer.shadowRadius = 10.0
        dotView.layer.shadowOpacity = 1.0
        dotView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
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
        let dotView = NoteCircleImageView(noteType: .gifts)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(noteDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        
        dotView.layer.shadowColor = UIColor.black.cgColor
        dotView.layer.shadowRadius = 10.0
        dotView.layer.shadowOpacity = 1.0
        dotView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return dotView
    }()

    private lazy var plansNoteDot: NoteCircleImageView = {
        let dotView = NoteCircleImageView(noteType: .plans)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(noteDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        
        dotView.layer.shadowColor = UIColor.black.cgColor
        dotView.layer.shadowRadius = 10.0
        dotView.layer.shadowOpacity = 1.0
        dotView.layer.shadowOffset = CGSize(width: 0, height: 0)
        dotView.layer.shadowColor = UIColor.black.cgColor
        dotView.layer.shadowRadius = 10.0
        dotView.layer.shadowOpacity = 1.0
        dotView.layer.shadowOffset = CGSize(width: 0, height: 0)
        return dotView
    }()

    private lazy var otherNoteDot: NoteCircleImageView = {
        let dotView = NoteCircleImageView(noteType: .misc)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(noteDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        
        dotView.layer.shadowColor = UIColor.black.cgColor
        dotView.layer.shadowRadius = 10.0
        dotView.layer.shadowOpacity = 1.0
        dotView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
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
        eventDotStackView.addArrangedSubview(customDot)
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
        case .custom:           customDot.setSelectedState(isSelected: isSelected)
        case .other:             otherDot.setSelectedState(isSelected: isSelected)
        }
    }
    
    func toggleDotFor(noteType: NoteType, isSelected: Bool) {
        switch noteType {
        case .gifts: giftsNoteDot.setSelectedState(isSelected: isSelected)
        case .plans: plansNoteDot.setSelectedState(isSelected: isSelected)
        case .misc: otherNoteDot.setSelectedState(isSelected: isSelected)
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
    
    func reloadData() {
        DispatchQueue.main.async {
            UIView.transition(
                with: self.tableView,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: {
                    self.tableView.reloadData()
                }, completion: nil)
        }
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
            return UIScreen.main.bounds.width/9 + 65
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
        return indexPath.section == 0 ? 0 : UITableView.automaticDimension
    }
}

// MARK: - UITableViewDelegate

extension EventsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = activeEvents[safe: indexPath.section - 1] else { return }
        
        if
            let eventNotes = event.notes,
            !eventNotes.isEmpty,
            let noteType = activeNoteTypes[safe: indexPath.row],
            let selectedNote = eventNotes.filter({ $0.noteType == noteType }).first
        {
            let noteState = NoteState.existingNote(selectedNote)
            delegate?.didSelectNote(noteState: noteState)
        } else {
            let noteType = activeNoteTypes[safe: indexPath.row] ?? .gifts
            let noteState = NoteState.newNote(noteType, event)
            delegate?.didSelectNote(noteState: noteState)
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
    }
}
