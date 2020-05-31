//
//  InitialImportInteractorInputting.swift
//  Date Dots
//
//  Created by Aaron Williamson on 2/12/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import Foundation

protocol InitialImportInteractorInputting: class {

    func syncContacts(handleContacts: @escaping () -> Void)
}
