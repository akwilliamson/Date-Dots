//
//  Constant.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import Foundation

protocol Stringable: RawRepresentable {
    var value: String { get }
}

extension Stringable {
    var value: String { return rawValue as? String ?? "Not Stringable" }
}

struct Constant {
    
    enum UserDefaults: String, Stringable {
    
        case hasLaunchedOnce = "hasLaunchedOnce"
    }
    
    enum StoryboardId: String, Stringable {
        
        case main = "Main"
        
        var storyboard: UIStoryboard {
            return UIStoryboard(name: self.value, bundle: nil)
        }
        
        func vc<T>(id: Constant.ViewControllerId) -> T {
            
            return self.storyboard.instantiateViewController(withIdentifier: id.value) as! T
        }

    }
    
    enum ViewControllerId: String, Stringable {
        
        case initialImport   = "InitialImport"
        case tabBar          = "TabBar"
        case datesNavigation = "DatesNavigation"
        case dates           = "Dates"
    }
    
    enum CellId: String, Stringable {
        
        case dateCell = "DateCell"
    }
}
