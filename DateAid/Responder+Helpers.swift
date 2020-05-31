//
//  ResponderExtension.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/20/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

extension UIResponder {
    
    fileprivate struct CurrentFirstResponder {
        weak static var currentFirstResponder: UIResponder?
    }
    fileprivate class var currentFirstResponder: UIResponder? {
        get { return CurrentFirstResponder.currentFirstResponder }
        set(newValue) { CurrentFirstResponder.currentFirstResponder = newValue }
    }
    
    class func getCurrentFirstResponder() -> UIResponder? {
        currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder), to: nil, from: nil, for: nil)
        return currentFirstResponder
    }
    
    @objc func findFirstResponder() {
        UIResponder.currentFirstResponder = self
    }
}
