 //
//  NoteVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/21/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData
 
enum NoteType {
    case gifts
    case plans
    case other
    
    var title: String {
        switch self {
        case .gifts:  return "Gifts"
        case .plans: return "Plans"
        case .other:  return "Other"
        }
    }
}

class NoteViewController: UIViewController {
    
    // MARK: UI
    
    private var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNote))
        return barButtonItem
    }()

    // MARK: Properties

    var event: Date
    var noteType: NoteType
    var note: Note?
    
    var managedContext: NSManagedObjectContext?
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(event: Date, noteType: NoteType) {
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
        title = noteType.title
        view.backgroundColor = .white
        navigationController?.navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    private func constructSubviews() {
        view.addSubview(textView)
    }
    
    private func constrainSubviews() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    // MARK: View Setup

    private func configureNote() {
        guard let note = note else { addPlaceholderText(); return }

        textView.text = note.body
    }

    private func addPlaceholderText() {
        switch noteType {
        case .gifts: textView.text = "A place for gift ideas"
        case .plans: textView.text = "A place for event plans"
        case .other: textView.text = "A place for other ideas"
        }
        textView.textColor = UIColor.lightGray
    }

    // MARK: Actions

    @objc
    func saveNote() {
        saveContext()
        _ = navigationController?.popViewController(animated: true)
    }

    private func saveContext() {
        guard let managedContext = managedContext else { return }

        if let note = note {
            note.body = textView.text
        } else {
            createNewNote()
        }
        
        try? managedContext.save()
    }
    
    private func createNewNote() {
        guard
            let managedContext = managedContext,
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext),
            let existingNotes = event.notes as? NSMutableSet
        else {
            return
        }

        let newNote = Note(entity: entity, insertInto: managedContext)
        
        newNote.title = noteType.title
        newNote.body = textView.text
        
        existingNotes.add(newNote)
        event.notes = existingNotes.copy() as? Set<Note>
    }
}
 
// MARK: UITextViewDelegate

extension NoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = event.color
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("wtf")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            addPlaceholderText()
        }
    }
}
