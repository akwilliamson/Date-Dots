//
//  NotesNavigationPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NotesNavigationEventHandling: class {

    func viewDidLoad()
    func showNotes(in navigation: NotesNavigationViewController?)
}

class NotesNavigationPresenter {
    
    // MARK: Properties
    
    weak var wireframe: NotesNavigationWireframe?
    var view: NotesNavigationViewController?

    private enum Constant {
        enum Style {
            static let barTintColor = UIColor.compatibleSystemGray3
            static let tintColor = UIColor.compatibleLabel
            static let foregroundColor = UIColor.compatibleLabel
            static let font = FontType.noteworthyBold(23).font
        }
    }
}

// MARK: EventsNavigationEventHandling

extension NotesNavigationPresenter: NotesNavigationEventHandling {
    
    func viewDidLoad() {
        view?.configureNavigation(barTintColor: Constant.Style.barTintColor, tintColor: Constant.Style.tintColor)
        view?.configureNavigation(titleTextAttributes: [
            NSAttributedString.Key.foregroundColor: Constant.Style.foregroundColor,
            NSAttributedString.Key.font: Constant.Style.font
        ])
    }

    func showNotes(in navigation: NotesNavigationViewController?) {
        wireframe?.presentNotes(in: navigation)
    }
}
