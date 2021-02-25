//
//  NoteType.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/24/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

enum NoteType {
    
    case gifts
    case plans
    case other
    
    var title: String {
        switch self {
        case .gifts:  return "Gifts"
        case .plans: return "Plans"
        case .other:  return "Other"
        }
    }
}
