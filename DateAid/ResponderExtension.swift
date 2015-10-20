//
//  ResponderExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/20/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension UIResponder {
    
    private struct CurrentFirstResponder {
        weak static var currentFirstResponder: UIResponder?
    }
    private class var currentFirstResponder: UIResponder? {
        get { return CurrentFirstResponder.currentFirstResponder }
        set(newValue) { CurrentFirstResponder.currentFirstResponder = newValue }
    }
    
    class func getCurrentFirstResponder() -> UIResponder? {
        currentFirstResponder = nil
        UIApplication.sharedApplication().sendAction("findFirstResponder", to: nil, from: nil, forEvent: nil)
        return currentFirstResponder
    }
    
    func findFirstResponder() {
        UIResponder.currentFirstResponder = self
    }
}