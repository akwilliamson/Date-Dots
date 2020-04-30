//
//  InitialImportPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/15/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

class InitialImportPresenter {
    
    weak var wireframe: InitialImportWireframe?
    weak var view: InitialImportViewOutputting?
    var interactor: InitialImportInteractor?
}

extension InitialImportPresenter: InitialImportEventHandling {
    
    func syncContactsPressed(in window: UIWindow?) {
        interactor?.syncContacts {
            DispatchQueue.main.async() {
                self.showTabBar(in: window)
            }
        }
    }
    
    func showTabBar(in window: UIWindow?) {
        wireframe?.presentTabBar(in: window)
    }
}

extension InitialImportPresenter: InitialImportInteractorOutputting {

}
