//
//  NotesPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NotesEventHandling: class {

    func viewDidLoad()
    
    func numberOfSections() -> Int
    func numberOfNotes(for section: Int) -> Int
    func noteTitle(for section: Int) -> String
    func cellTitle(for indexPath: IndexPath) -> String
    func cellSubtitle(for indexPath: IndexPath) -> String
}

protocol NotesInteractorOutputting: class {}

class NotesPresenter {

    // MARK: VIPER
    
    public var view: NotesViewOutputting?
    public var interactor: NotesInteractorInputting?
    public weak var wireframe: NotesWireframe?
    
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
        giftsNotes = notes.filter({ $0.title?.lowercased() == NoteType.gifts.title.lowercased() })
        plansNotes = notes.filter({ $0.title?.lowercased() == NoteType.plans.title.lowercased() })
        otherNotes = notes.filter({ $0.title?.lowercased() == NoteType.other.title.lowercased() })
    }
}

extension NotesPresenter: NotesEventHandling {
    
    func viewDidLoad() {
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
    
    func numberOfSections() -> Int {
        return 3 // Gifts, Plans, Notes
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
    
    func noteTitle(for section: Int) -> String {
        switch section {
        case 0: return Constant.String.gifts
        case 1: return Constant.String.plans
        case 2: return Constant.String.other
        default:
            return String()
        }
    }
    
    func cellTitle(for indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0: return giftsNotes[indexPath.row].date?.abbreviatedName ?? String()
        case 1: return plansNotes[indexPath.row].date?.abbreviatedName ?? String()
        case 2: return otherNotes[indexPath.row].date?.abbreviatedName ?? String()
        default:
            return String()
        }
    }
    
    func cellSubtitle(for indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0: return giftsNotes[indexPath.row].body ?? String()
        case 1: return plansNotes[indexPath.row].body ?? String()
        case 2: return otherNotes[indexPath.row].body ?? String()
        default:
            return String()
        }
    }
}
    
extension NotesPresenter: NotesInteractorOutputting {}
