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
    func didSelectNote(noteState: NoteState)
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
        stackView.spacing = 12
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var birthdayDot: EventCircleImageView = {
        let dotView = EventCircleImageView(eventType: .birthday)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        
        return dotView
    }()

    private lazy var anniversaryDot: EventCircleImageView = {
        let dotView = EventCircleImageView(eventType: .anniversary)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        
        return dotView
    }()

    private lazy var customDot: EventCircleImageView = {
        let dotView = EventCircleImageView(eventType: .custom)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        
        return dotView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NoteCell.self, forCellReuseIdentifier: "NoteCell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var noteDotStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var giftsNoteDot: NoteCircleImageView = {
        let dotView = NoteCircleImageView(noteType: .gifts)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(noteDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        
        return dotView
    }()

    private lazy var plansNoteDot: NoteCircleImageView = {
        let dotView = NoteCircleImageView(noteType: .plans)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(noteDotPressed))
        dotView.addGestureRecognizer(tapGesture)

        return dotView
    }()

    private lazy var otherNoteDot: NoteCircleImageView = {
        let dotView = NoteCircleImageView(noteType: .misc)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(noteDotPressed))
        dotView.addGestureRecognizer(tapGesture)
        
        return dotView
    }()
    
    private var noEventsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.isHidden = true
        return stackView
    }()
    
    private var noEventsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.systemGray
        label.text = "No Events"
        label.font = FontType.avenirNextDemiBold(30).font
        return label
    }()
    
    private var noEventsDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.systemGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Add or toggle events to display them here"
        label.font = FontType.avenirNextMedium(20).font
        return label
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
        addSubview(noEventsStackView)
            noEventsStackView.addArrangedSubview(noEventsTitleLabel)
            noEventsStackView.addArrangedSubview(noEventsDescriptionLabel)
        addSubview(eventDotStackView)
            eventDotStackView.addArrangedSubview(birthdayDot)
            eventDotStackView.addArrangedSubview(anniversaryDot)
            eventDotStackView.addArrangedSubview(customDot)
        addSubview(noteDotStackView)
            noteDotStackView.addArrangedSubview(giftsNoteDot)
            noteDotStackView.addArrangedSubview(plansNoteDot)
            noteDotStackView.addArrangedSubview(otherNoteDot)
    }
    
    override func constructLayout() {
        super.constructLayout()
        NSLayoutConstraint.activate([
            eventDotStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            eventDotStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 60),
            eventDotStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -60)
        ])
        NSLayoutConstraint.activate([
            birthdayDot.heightAnchor.constraint(equalTo: birthdayDot.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            noteDotStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noteDotStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            giftsNoteDot.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/6),
            giftsNoteDot.heightAnchor.constraint(equalTo: giftsNoteDot.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            noEventsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noEventsStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            noEventsDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            noEventsDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: Interface
    
    func toggleDotFor(eventType: EventType, isSelected: Bool) {
        switch eventType {
        case .birthday:       birthdayDot.setSelectedState(isSelected: isSelected)
        case .anniversary: anniversaryDot.setSelectedState(isSelected: isSelected)
        case .custom:           customDot.setSelectedState(isSelected: isSelected)
        }
        if eventDotStackView.isHidden {
            eventDotStackView.alpha = 0
            eventDotStackView.isHidden = false
            
            UIView.animate(withDuration: 0.2) {
                self.eventDotStackView.alpha = 1
            }
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
        UIView.animate(withDuration: 0.2) {
            self.giftsNoteDot.alpha = 0
            self.plansNoteDot.alpha = 0
            self.otherNoteDot.alpha = 0
        } completion: { _ in
            self.noteDotStackView.isHidden = true
        }
    }
    
    func showNoteDots() {
        UIView.animate(withDuration: 0.2) {
            self.giftsNoteDot.alpha = 1
            self.plansNoteDot.alpha = 1
            self.otherNoteDot.alpha = 1
        } completion: { _ in
            self.noteDotStackView.isHidden = false
        }
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
                options: .transitionCrossDissolve
            ) {
                self.tableView.reloadData()
                if self.activeEvents.isEmpty {
                    self.noEventsTitleLabel.alpha = 1
                    self.noEventsDescriptionLabel.alpha = 1
                } else {
                    self.noEventsTitleLabel.alpha = 0
                    self.noEventsDescriptionLabel.alpha = 0
                }
            } completion: { bool in
                if self.activeEvents.isEmpty {
                    self.noEventsStackView.isHidden = false
                } else {
                    self.noEventsStackView.isHidden = true
                }
            }
        }
    }
    
    // MARK: Actions
    
    @objc
    func eventDotPressed(_ sender: UITapGestureRecognizer) {
        guard let dot = sender.view as? EventCircleImageView else { return }
        dot.spring()
        delegate?.didPressDot(eventType: dot.eventType)
    }
    
    @objc
    func noteDotPressed(_ sender: UITapGestureRecognizer) {
        guard let dot = sender.view as? NoteCircleImageView else { return }
        dot.spring()
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
            return 50
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
