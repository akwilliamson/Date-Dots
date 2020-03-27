//
//  CircleView.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/22/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class CircleLabel: UILabel {
    
    var index: Int!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.bounds.width/2
        self.clipsToBounds = true
        super.draw(rect)
    }
    
    override func drawText(in rect: CGRect) {
        self.textColor = UIColor.white
        super.drawText(in: rect)
    }
    
    func setProperties(_ borderWidth: Float, borderColor: UIColor) {
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.cgColor
    }
    
    func animateDropIn(withDelay delay: TimeInterval) {
        self.center.y = -50
        UIView.animate(withDuration: 1, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.center.y = 84
            }, completion: nil)
    }
    
    func rollRight(forDuration duration: TimeInterval, inView view: UIView, closure: @escaping (CircleLabel) -> ()) {
        self.rotate360Degrees()
        UIView.animate(withDuration: duration, animations: { 
            self.center.x = view.frame.width - (self.center.x)
            }, completion: { _ in
                closure(self)
        }) 
    }
    
    func rollLeft(forDuration duration: TimeInterval, toPosition position: CGFloat, closure: @escaping (CircleLabel, String) -> ()) {
        self.rotateBack360Degrees()
        let text = self.text!
        UIView.animate(withDuration: duration, animations: { 
            self.center.x = position
            self.text = "✓"
            }, completion: { _ in
                closure(self, text)
        }) 
    }
    
    func addTapGestureRecognizer(forAction action: String, inController controller: UIViewController) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: controller, action: Selector(action))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func animate(intoView view: UIView, toPosition position: CGFloat, withDelay delay: TimeInterval) {
        self.center.x = -view.frame.width - self.frame.height
        UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: { 
            self.center.x = position
            }) { _ in
        }
    }
}
