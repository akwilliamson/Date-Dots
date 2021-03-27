//
//  NoteDetailsPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/3/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NoteDetailsEventHandling: class {
    // Setup
    func viewDidLoad()
    // Input Actions
    func didBeginEditingSubject()
    func didChangeSubject(text: String?)
    func didEndEditingSubject()
    func didBeginEditingDescription()
    func didChangeDescription(text: String?)
    func didEndEditingDescription()
    // Navigation Actions
    func willChooseEvent()
    func didChooseEvent(_ event: Event)
    func didTapViewEventDetails()
    // Note Actions
    func didTapEdit()
    func didTapSave()
    func didTapDelete()
}

protocol NoteDetailsInteractorOutputting: class {
    
    func noteSaved()
    func noteSaveFailed()
    func noteDeleted()
    func noteDeleteFailed()
}

class NoteDetailsPresenter {
    
    // MARK: VIPER
    
    var view: NoteDetailsViewOutputting?
    var interactor: NoteDetailsInteractorInputting?
    var wireframe: NoteDetailsRouting?
    
    // MARK: Constants
    
    private struct Constant {
        static let placeholderSubject = "Note Title"
        static let placeholderDescription = "Note Details"
    }
    
    // MARK: Properties
    
    var event: Event?
    var noteState: NoteState?
    
    private var subjectText: String?
    private var descriptionText: String?
}

extension NoteDetailsPresenter: NoteDetailsEventHandling {
    
    func viewDidLoad() {
        // TODO: set event here, we'll need to pass it in via the wireframe
        guard let noteState = noteState else { return }
        
        switch noteState {
        case .existingNote(let note):
            view?.setContent(
                NoteDetailsView.Content(
                    isNewNote: false,
                    hasEvent: true,
                    isEditable: false,
                    eventType: note.event.eventType,
                    name: note.event.fullName,
                    noteType: note.noteType,
                    subject: note.subject ?? Constant.placeholderSubject,
                    description: note.body ?? Constant.placeholderDescription
                )
            )
        case .newNote(let newNoteType):
            view?.setContent(
                NoteDetailsView.Content(
                    isNewNote: true,
                    hasEvent: false,
                    isEditable: true,
                    eventType: nil,
                    name: nil,
                    noteType: newNoteType,
                    subject: Constant.placeholderSubject,
                    description: Constant.placeholderDescription
                )
            )
        }
    }
    
    func willChooseEvent() {
        wireframe?.presentEventList()
    }
    
    func didChooseEvent(_ event: Event) {
        self.event = event

        guard let noteType = noteState?.noteType else { return }
        
        if let note = event.note(forType: noteType) {
            noteState = .existingNote(note)
        } else {
            noteState = .newNote(noteType)
        }
        
        guard let noteState = noteState else { return }
        
        switch noteState {
        case .existingNote(let note):
            view?.setContent(
                NoteDetailsView.Content(
                    isNewNote: false,
                    hasEvent: true,
                    isEditable: true,
                    eventType: note.event.eventType,
                    name: note.event.fullName,
                    noteType: note.noteType,
                    subject: note.subject ?? Constant.placeholderSubject,
                    description: note.body ?? Constant.placeholderDescription
                )
            )
        case .newNote(let newNoteType):
            view?.setContent(
                NoteDetailsView.Content(
                    isNewNote: true,
                    hasEvent: true,
                    isEditable: true,
                    eventType: event.eventType,
                    name: event.fullName,
                    noteType: newNoteType,
                    subject: Constant.placeholderSubject,
                    description: Constant.placeholderDescription
                )
            )
        }
    }
    
    func didBeginEditingSubject() {
        let isPlaceholder = subjectText.isEmptyOrNil || subjectText == Constant.placeholderSubject
        view?.startEditTextField(isPlaceholder: isPlaceholder)
    }
    
    func didChangeSubject(text: String?) {
        subjectText = (text.isEmptyOrNil || text == Constant.placeholderSubject) ? nil : text
    }
    
    func didEndEditingSubject() {
        view?.endEditTextField(isPlaceholder: subjectText.isEmptyOrNil)
    }
    
    func didBeginEditingDescription() {
        let isPlaceholder = descriptionText.isEmptyOrNil || descriptionText == Constant.placeholderDescription
        view?.startEditTextView(isPlaceholder: isPlaceholder)
    }
    
    func didChangeDescription(text: String?) {
        descriptionText = (text.isEmptyOrNil || text == Constant.placeholderDescription) ? nil : text
    }
    
    func didEndEditingDescription() {
        view?.endEditTextView(isPlaceholder: descriptionText.isEmptyOrNil)
    }
    
    func didTapEdit() {
        print("didTapEdit")
    }
    
    func didTapSave() {
        guard let event = event, let type = noteState?.noteType?.title else {
            let noteType = noteState?.noteType?.title ?? String()
            view?.showAlert(title: "Missing Event", description: "Choose an event for this \(noteType) note")
            return
        }

        guard !subjectText.isEmptyOrNil, let subjectText = subjectText else {
            view?.showAlert(title: "Missing Note Title", description: "Enter a title for this \(type) note")
            return
        }
        
        interactor?.saveNote(type: type, title: subjectText, description: descriptionText, for: event)
    }
    
    func didTapViewEventDetails() {
        print("didTapViewEventDetails")
    }
    
    func didTapDelete() {
        print("didTapDelete")
    }
}

extension NoteDetailsPresenter: NoteDetailsInteractorOutputting {
    
    func noteSaved() {
        wireframe?.dismiss()
    }
    
    func noteSaveFailed() {
        view?.showAlert(title: "Save Error", description: "Something went wrong. Try again")
    }
    
    func noteDeleted() {
        
    }
    
    func noteDeleteFailed() {
        
    }
}
