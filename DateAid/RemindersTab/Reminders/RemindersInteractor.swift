//
//  EventsInteractor.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

protocol RemindersInteractorInputting {}

class RemindersInteractor {
    
    weak var presenter: RemindersInteractorOutputting?
}

extension RemindersInteractor: RemindersInteractorInputting {}
