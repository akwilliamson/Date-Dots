//
//  DatesPresenterInteractorProtocol.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/24/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

protocol DatesInteractorPresenterProtocol: class {
    
    func styleSegmentedControl(with categories: [String]) -> Void
    func fetched(_ dates: [Date?]) -> Void
}
