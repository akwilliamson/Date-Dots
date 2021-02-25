//
//  EventsInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

protocol NotesInteractorInputting {
    func fetchNotes(completion: @escaping (Result<[Note], Error>) -> Void)
}

class NotesInteractor: CoreDataInteractable {
    
    weak var presenter: NotesInteractorOutputting?
}

extension NotesInteractor: NotesInteractorInputting {
    
    func fetchNotes(completion: @escaping (Result<[Note], Error>) -> Void) {
        do {
            let notes: [Note] = try moc.fetch()
            completion(.success(notes))
        } catch {
            completion(.failure(error))
        }
    }
}
