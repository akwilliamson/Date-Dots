//
//  DatesInteractorProtocol.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

protocol DatesPresenterInteractorProtocol: class {
    
    func dateFilterCategories() -> Void
    func fetchDates(for type: DateType?, sort descriptors: [String]?) -> Void
    func delete(_ date: Date) -> Void
}
