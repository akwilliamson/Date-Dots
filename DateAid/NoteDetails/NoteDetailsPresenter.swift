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
    func didTapEdit()
    func didTapSave()
    func didTapDelete()
    func didConfirmDelete()
}

protocol NoteDetailsInteractorOutputting: AnyObject {
    
    func noteSaved()
    func noteSaveFailed()
    func noteDeleted()
    func noteDeleteFailed()
}

class NoteDetailsPresenter {
    
    // MARK: VIPER
    
    weak var router: NoteDetailsRouter?
    var view: NoteDetailsViewOutputting?
    var interactor: NoteDetailsInteractorInputting?
    
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
        guard let noteState = noteState else { return }
        
        switch noteState {
        case .existingNote(let note):
            event = note.event
            view?.setNavigation(isNewNote: false, isEditableNote: false)
            view?.setContent(
                NoteDetailsView.Content(
                    name: note.event.fullName,
                    eventType: note.event.eventType,
                    noteType: note.noteType,
                    isNewNote: false,
                    isEditable: false,
                    subject: note.subject ?? Constant.placeholderSubject,
                    description: note.body  ?? Constant.placeholderDescription
                )
            )
        case .newNote(let noteType, let event):
            view?.setNavigation(isNewNote: true, isEditableNote: true)
            view?.setContent(
                NoteDetailsView.Content(
                    name: event.fullName,
                    eventType: event.eventType,
                    noteType: noteType,
                    isNewNote: true,
                    isEditable: true,
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
        view?.setNavigation(isNewNote: false, isEditableNote: true)
        view?.enableInputFields()
        view?.startEditTextField(isPlaceholder: false)
    }
    
    func didTapSave() {
        guard let event = event, let noteType = NoteType(rawValue: noteState?.noteType?.rawValue ?? String()) else {
            view?.showAlert(title: "Missing Event", description: "Choose an event for this note", shouldConfirm: false)
            return
        }

        guard !subjectText.isEmptyOrNil, let subjectText = subjectText else {
            view?.showAlert(title: "Missing Note Title", description: "Enter a title for this note", shouldConfirm: false)
            return
        }
        
        interactor?.saveNote(type: noteType, title: subjectText, description: descriptionText, for: event)
    }
    
    func didTapDelete() {
        view?.showAlert(title: "Are you sure?", description: "This note will permanently be deleted", shouldConfirm: true)
    }
    
    func didConfirmDelete() {
        guard let event = event, let noteType = NoteType(rawValue: noteState?.noteType?.rawValue ?? String()) else {
            view?.showAlert(title: "Delete Error", description: "Something went wrong. Try again", shouldConfirm: false)
            return
        }
        interactor?.deleteNote(type: noteType, for: event)
    }
}

extension NoteDetailsPresenter: NoteDetailsInteractorOutputting {
    
    func noteSaved() {
        // TODO: Add router dismiss notes
    }
    
    func noteSaveFailed() {
        view?.showAlert(title: "Save Error", description: "Something went wrong, please try again", shouldConfirm: false)
    }
    
    func noteDeleted() {
        // TODO: Add router dismiss notes
    }
    
    func noteDeleteFailed() {
        view?.showAlert(title: "Delete Error", description: "Something went wrong. Try again", shouldConfirm: false)
    }
}
