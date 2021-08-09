//
//  NoteDetailsInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/3/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import CoreData

protocol NoteDetailsInteractorInputting: AnyObject {
    
    func saveNote(type: NoteType, title: String, description: String?, for event: Event)
    func deleteNote(type: NoteType, for event: Event)
}

class NoteDetailsInteractor {
    
    weak var presenter: NoteDetailsInteractorOutputting?
}

extension NoteDetailsInteractor: NoteDetailsInteractorInputting {
    
    func saveNote(type: NoteType, title: String, description: String?, for event: Event) {

        if let existingNote = event.note(forType: type) {
            existingNote.subject = title
            existingNote.body = description
        } else {
            let newNote = Note(context: CoreDataManager.shared.viewContext)
            newNote.type = type.rawValue
            newNote.subject = title
            newNote.body = description
            newNote.event = event
            
            let existingNotes = event.notes as? NSMutableSet
            let mutableNotes = existingNotes?.mutableCopy() as? NSMutableSet ?? []
            mutableNotes.add(newNote)
            
            event.notes = mutableNotes as? Set<Note>
        }
        
        do {
            try CoreDataManager.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteNote(type: NoteType, for event: Event) {
        guard let existingNote = event.note(forType: type) else { return }
 
        do {
            try CoreDataManager.delete(object: existingNote)
            presenter?.noteDeleted(for: event)
        } catch {
            presenter?.noteDeleteFailed()
        }
    }
}
