//
//  NotesPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NotesEventHandling: class {
    
    func viewLoaded()
}

protocol NotesInteractorOutputting: class {}

class NotesPresenter {

    // MARK: VIPER
    
    public var view: NotesViewOutputting?
    public var interactor: NotesInteractorInputting?
    public weak var wireframe: NotesWireframe?
    
    // MARK: Constants
    
    // MARK: Constants

    private enum Constant {
        enum String {
            static let title = "Notes"
        }
        enum Image {
            static let iconSelected = UIImage(named: "selected-pencil")!.withRenderingMode(.alwaysTemplate)
            static let iconUnselected =  UIImage(named: "unselected-pencil")!.withRenderingMode(.alwaysTemplate)
        }
    }
}

extension NotesPresenter: NotesEventHandling {
    
    func viewLoaded() {
        view?.configureTabBar(image: Constant.Image.iconUnselected, selectedImage: Constant.Image.iconSelected)
    }
}
    
extension NotesPresenter: NotesInteractorOutputting {}
