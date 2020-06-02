//
//  CircleView.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/22/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import QuartzCore

class EventCircleLabel: CircleLabel {

    // MARK: Properties

    /// TODO: Get rid of this shit
    public var index = 0

    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: UIColor) {
        super.init(frame: .zero)
        backgroundColor = color
        textColor = .white
        lineBreakMode = .byWordWrapping
    }
    
    public func updateColor(to color: UIColor) {
        backgroundColor = color
    }

    // MARK: Public Methods

    public func rollRight(forDuration duration: TimeInterval, inView view: UIView, closure: @escaping (EventCircleLabel) -> ()) {
        UIView.animate(withDuration: duration, animations: { 
            self.center.x = view.frame.width - (self.center.x)
        }, completion: { _ in
            closure(self)
        }) 
    }
    
    public func rollLeft(forDuration duration: TimeInterval, toPosition position: CGFloat, closure: @escaping (EventCircleLabel, String) -> ()) {
        let text = self.text!
        UIView.animate(withDuration: duration, animations: { 
            self.center.x = position
            self.text = "✓"
            }, completion: { _ in
                closure(self, text)
        }) 
    }

    public func addTapGestureRecognizer(forAction action: String, inController controller: UIViewController) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: controller, action: Selector(action))
        tapGestureRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    public func animate(intoView view: UIView, toPosition position: CGFloat, withDelay delay: TimeInterval) {
        center.x = -view.frame.width - frame.height
        UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: {
            self.center.x = position
            }) { _ in
        }
    }
}
