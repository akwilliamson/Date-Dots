//
//  NotesPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NotesEventHandling: class {

    // Actions
    func viewDidLoad()
    func viewWillAppear()
    func didSelectRow(at indexPath: IndexPath)
    func didSelectSection(at section: Int)
    // Data
    func numberOfSections() -> Int
    func title(for section: Int) -> String
    func numberOfNotes(for section: Int) -> Int
    func note(for indexPath: IndexPath) -> Note?
}

protocol NotesInteractorOutputting: class {}

class NotesPresenter {

    // MARK: VIPER
    
    var view: NotesViewOutputting?
    var interactor: NotesInteractorInputting?
    var wireframe: NotesWireframe?
    
    // MARK: Constants

    private enum Constant {
        enum String {
            static let title = "Notes"
            static let gifts = "Gifts"
            static let plans = "Plans"
            static let other = "Other"
        }
        enum Image {
            static let iconSelected = UIImage(named: "selected-pencil")!.withRenderingMode(.alwaysTemplate)
            static let iconUnselected =  UIImage(named: "unselected-pencil")!.withRenderingMode(.alwaysTemplate)
        }
    }
    
    // MARK: Properties
    
    private var giftsNotes: [Note] = []
    private var plansNotes: [Note] = []
    private var otherNotes: [Note] = []
    
    private func set(notes: [Note]) {
        giftsNotes = notes.filter({ $0.type.lowercased() == NoteType.gifts.rawValue })
        plansNotes = notes.filter({ $0.type.lowercased() == NoteType.plans.rawValue })
        otherNotes = notes.filter({ $0.type.lowercased() == NoteType.other.rawValue })
    }
}

extension NotesPresenter: NotesEventHandling {
    
    func viewDidLoad() {
        view?.configureNavigationBar(title: Constant.String.title)
    }
    
    func viewWillAppear() {
        interactor?.fetchNotes { result in
            switch result {
            case .success(let notes):
                self.set(notes: notes)
                self.view?.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let note = note(for: indexPath) else { return }
        
        let noteState = NoteState.existingNote(note)
        wireframe?.presentNoteDetails(noteState: noteState)
    }
    
    func didSelectSection(at section: Int) {
        let noteState: NoteState
        
        switch section {
        case 0: noteState = .newNote(.gifts)
        case 1: noteState = .newNote(.plans)
        case 2: noteState = .newNote(.other)
        default:
            return
        }
        
        wireframe?.presentNoteDetails(noteState: noteState)
    }
    
    func numberOfSections() -> Int {
        return 3 // Gifts, Plans, Notes
    }
    
    func title(for section: Int) -> String {
        switch section {
        case 0: return NoteType.gifts.rawValue.capitalized
        case 1: return NoteType.plans.rawValue.capitalized
        case 2: return NoteType.other.rawValue.capitalized
        default:
            return String()
        }
    }
    
    func numberOfNotes(for section: Int) -> Int {
        switch section {
        case 0: return giftsNotes.count
        case 1: return plansNotes.count
        case 2: return otherNotes.count
        default:
            return 0
        }
    }
    
    func note(for indexPath: IndexPath) -> Note? {
        switch indexPath.section {
        case 0: return giftsNotes[safe: indexPath.row]
        case 1: return plansNotes[safe: indexPath.row]
        case 2: return otherNotes[safe: indexPath.row]
        default:
            return Note()
        }
    }
}
    
extension NotesPresenter: NotesInteractorOutputting {}
