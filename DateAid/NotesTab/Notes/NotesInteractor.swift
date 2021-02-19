//
//  EventsInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

protocol NotesInteractorInputting {}

class NotesInteractor {
    
    weak var presenter: NotesInteractorOutputting?
}

extension NotesInteractor: NotesInteractorInputting {}
