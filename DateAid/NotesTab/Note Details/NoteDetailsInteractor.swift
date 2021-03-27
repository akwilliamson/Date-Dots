//
//  NoteDetailsInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/3/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import CoreData

protocol NoteDetailsInteractorInputting: class {
    
    func saveNote(type: String, title: String, description: String?, for event: Event)
}

class NoteDetailsInteractor: CoreDataInteractable {
    
    weak var presenter: NoteDetailsInteractorOutputting?
}

extension NoteDetailsInteractor: NoteDetailsInteractorInputting {
    
    func saveNote(type: String, title: String, description: String?, for event: Event) {
        guard
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: moc)
        else {
            presenter?.noteSaveFailed()
            return
        }
        
        let newNote = Note(entity: entity, insertInto: moc)
        
        newNote.type = ""
        newNote.subject = title
        newNote.body = description
        
        let existingNotes = event.notes as? NSMutableSet ?? []
        
        existingNotes.add(newNote)
        event.notes = existingNotes.copy() as? Set<Note>
        
        presenter?.noteSaved()
    }
}
