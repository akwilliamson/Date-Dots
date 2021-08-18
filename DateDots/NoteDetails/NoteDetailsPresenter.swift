//
//  NoteDetailsPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/3/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NoteDetailsEventHandling: AnyObject {
    // Setup
    func viewDidLoad()
    // Input Actions
    func didBeginEditingSubject()
    func didChangeSubject(text: String?)
    func didEndEditingSubject()
    func didBeginEditingDescription()
    func didChangeDescription(text: String?)
    func didEndEditingDescription()
    // Note Actions
    func didTapDelete()
    func didConfirmDelete()
}

protocol NoteDetailsInteractorOutputting: AnyObject {
    
    func noteDeleted(for event: Event)
    func noteDeleteFailed()
}

class NoteDetailsPresenter {
    
    // MARK: VIPER
    
    weak var router: NoteDetailsRouter?
    var view: NoteDetailsViewOutputting?
    var interactor: NoteDetailsInteractorInputting?
    
    // MARK: Properties
    
    var noteState: NoteState
    var event: Event?
    
    private var subjectText: String?
    private var descriptionText: String?
    
    private var subjectIsEmpty: Bool {
        subjectText.isEmptyOrNil ||
        subjectText == "Gift Ideas Title"  ||
        subjectText == "Event Plans Title" ||
        subjectText == "Misc Notes Title"
    }
    
    private var descriptionIsEmpty: Bool {
        descriptionText.isEmptyOrNil ||
        descriptionText == "Gift Ideas Description"  ||
        descriptionText == "Event Plans Description" ||
        descriptionText == "Misc Notes Description"
    }
    
    init(noteState: NoteState) {
        self.noteState = noteState
    }
}

extension NoteDetailsPresenter: NoteDetailsEventHandling {
    
    func viewDidLoad() {
        let placeholderTitle: String
        let placeholderDescription: String
        
        switch noteState.noteType {
        case .gifts:
            view?.setNavigation(title: "Gift Ideas")
            placeholderTitle = "Gift Ideas Title"
            placeholderDescription = "Gift Ideas Description"
        case .plans:
            view?.setNavigation(title: "Event Plans")
            placeholderTitle = "Event Plans Title"
            placeholderDescription = "Event Plans Description"
        case .misc:
            view?.setNavigation(title: "Misc Notes")
            placeholderTitle = "Misc Notes Title"
            placeholderDescription = "Misc Notes Description"
        }
        
        switch noteState {
        case .existingNote(let note):
            view?.setNavigationBarDeleteButton()
            self.event = note.event
            subjectText = note.subject
            descriptionText = note.body
            
            view?.setContent(
                NoteDetailsView.Content(
                    eventName: note.event.fullName,
                    eventType: note.event.eventType,
                    noteType: note.noteType,
                    subjectIsEmpty: subjectIsEmpty,
                    descriptionIsEmpty: descriptionIsEmpty,
                    subject: note.subject ?? placeholderTitle,
                    description: note.body  ?? placeholderDescription
                )
            )
        case .newNote(let noteType, let event):
            self.event = event
            
            view?.setContent(
                NoteDetailsView.Content(
                    eventName: event.fullName,
                    eventType: event.eventType,
                    noteType: noteType,
                    subjectIsEmpty: true,
                    descriptionIsEmpty: true,
                    subject: placeholderTitle,
                    description: placeholderDescription
                )
            )
        }
    }
    
    func didBeginEditingSubject() {
        view?.startEditTextField(isPlaceholder: subjectIsEmpty)
    }
    
    func didChangeSubject(text: String?) {
        subjectText = text
    }
    
    func didEndEditingSubject() {
        if subjectIsEmpty {
            subjectText = nil
        }
        saveNote()
        view?.endEditTextField(isPlaceholder: subjectIsEmpty)
    }
    
    private func saveNote() {
        if
            let event = event,
            let noteType = NoteType(rawValue: noteState.noteType.rawValue)
        {
            if let subjectText = subjectText, !subjectText.isEmpty {
                interactor?.saveNote(type: noteType, title: subjectText, description: descriptionText, for: event)
            } else {
                interactor?.saveNote(type: noteType, title: noteState.noteType.rawValue.capitalized, description: descriptionText, for: event)
            }
        }
    }
    
    func didBeginEditingDescription() {
        view?.startEditTextView(isPlaceholder: descriptionIsEmpty)
    }
    
    func didChangeDescription(text: String?) {
        descriptionText = text
    }
    
    func didEndEditingDescription() {
        if descriptionIsEmpty {
            descriptionText = nil
        }
        saveNote()
        view?.endEditTextView(isPlaceholder: descriptionIsEmpty)
    }
    
    func didTapDelete() {
        view?.showAlert(title: "Are you sure?", description: "This note will permanently be deleted", shouldConfirm: true)
    }
    
    func didConfirmDelete() {
        guard
            let event = event,
            let noteType = NoteType(rawValue: noteState.noteType.rawValue)
        else {
            view?.showAlert(title: "Delete Error", description: "Something went wrong. Try again", shouldConfirm: false)
            return
        }
        interactor?.deleteNote(type: noteType, for: event)
    }
}

extension NoteDetailsPresenter: NoteDetailsInteractorOutputting {
    
    func noteDeleted(for event: Event) {
        router?.dismiss(event: event)
    }
    
    func noteDeleteFailed() {
        view?.showAlert(title: "Delete Error", description: "Something went wrong. Try again", shouldConfirm: false)
    }
}
