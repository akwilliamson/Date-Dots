//
//  DatesInteractorProtocol.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

protocol DatesInteractorInputting: class {
    
    func fetch(dates type: String) -> Void
    func delete(_ date: Date?, complete: (Bool) -> ())
}
