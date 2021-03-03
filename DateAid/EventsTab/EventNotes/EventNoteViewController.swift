 //
//  NoteVC.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/21/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class EventNoteViewController: UIViewController, CoreDataInteractable {
    
    // MARK: UI
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            textView.font = FontType.avenirNextDemiBold(20).font
        default:
            textView.font = FontType.avenirNextDemiBold(25).font
        }
        return textView
    }()

    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNote))
        return barButtonItem
    }()

    // MARK: Properties

    var event: Event
    var noteType: NoteType
    var note: Note?

    var showPlaceholderText = true
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(event: Event, noteType: NoteType) {
        self.event = event
        self.noteType = noteType
        self.note = event.note(forType: noteType)
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        constructSubviews()
        constrainSubviews()
        configureNote()
    }

    private func configureView() {
        title = noteType.title.capitalized
        view.backgroundColor = .compatibleSystemBackground
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    private func constructSubviews() {
        view.addSubview(textView)
    }
    
    private func constrainSubviews() {
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
                textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
                textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
                textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12)
            ])
        default:
            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            ])
        }
    }

    // MARK: View Setup

    private func configureNote() {
        if let noteText = note?.body, !noteText.isEmpty {
            showPlaceholderText = false
            textView.text = noteText
        }  else {
            showPlaceholderText = true
            configurePlaceholderText()
        }
    }

    private func configurePlaceholderText() {
        switch noteType {
        case .gifts: textView.text = "A place for gift ideas"
        case .plans: textView.text = "A place for event plans"
        case .other: textView.text = "A place for other ideas"
        }
        textView.textColor = UIColor.compatiblePlaceholderText
    }

    // MARK: Actions

    @objc
    func saveNote() {
        saveContext()
    }

    private func saveContext() {
        
        if let note = note {
            note.body = textView.text
        } else {
            createNewNote()
        }
        
        do {
            try moc.save()
            _ = navigationController?.popViewController(animated: true)
        }  catch {
            print(error.localizedDescription)
        }
    }
    
    private func createNewNote() {
        guard
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: moc),
            let existingNotes = event.notes as? NSMutableSet
        else {
            return
        }

        let newNote = Note(entity: entity, insertInto: moc)
        
        newNote.type = noteType.title
        newNote.body = textView.text
        
        existingNotes.add(newNote)
        event.notes = existingNotes.copy() as? Set<Note>
    }
}
 
// MARK: UITextViewDelegate

extension EventNoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if showPlaceholderText == true {
            showPlaceholderText = false
            textView.text = nil
            textView.textColor = event.eventType.color
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            showPlaceholderText = true
            configurePlaceholderText()
        }
    }
}
