//
//  NoteDetailType.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/3/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

enum NoteState {
    /// A note already exists to view
    case existingNote(Note)
    /// A new note is being created
    case newNote(NoteType)
    
    var noteType: NoteType? {
        switch self {
        case let .newNote(noteType):
            return noteType
        case let .existingNote(note):
            return note.noteType
        }
    }
}
