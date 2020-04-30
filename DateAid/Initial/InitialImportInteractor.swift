//
//  InitialImportInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/12/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import Foundation

class InitialImportInteractor {
    
    weak var presenter: InitialImportInteractorOutputting?
}

extension InitialImportInteractor: InitialImportInteractorInputting {
    
    func syncContacts(handleContacts: @escaping () -> Void) {
        ContactManager.syncContacts {
            handleContacts()
        }
    }
}
