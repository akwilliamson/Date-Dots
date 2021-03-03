//
//  NoteType.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/24/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

enum NoteType: Int {
    
    case gifts
    case plans
    case other
    
    var title: String {
        switch self {
        case .gifts: return "gifts"
        case .plans: return "plans"
        case .other: return "other"
        }
    }
}
