//
//  DateSegmentedControl.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/16/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

@IBDesignable class DateSegmentedControl: UIControl {
    
    private var labels = [UILabel]()
    var thumbView = UIView()
    
    var items: [String] = ["Item 1", "Item 2", "Item 3", "Item 4"] {
        didSet { setupLabels() }
    }
    
    var selectedIndex: Int = 0
    
    @IBInspectable var selectedLabelColor: UIColor = .black {
        didSet { labels[selectedIndex].textColor = selectedLabelColor }
    }
    
    @IBInspectable var unselectedLabelColor: UIColor = .white {
        didSet { labels.forEach({ $0.textColor = unselectedLabelColor }) }
    }
    
    @IBInspectable var thumbColor: UIColor = .birthday {
        didSet { layer.backgroundColor = thumbColor.cgColor }
    }
    
    @IBInspectable var borderColor: UIColor = .white {
        didSet { layer.borderColor = borderColor.cgColor }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        backgroundColor = UIColor(white: 0, alpha: 0.15)
        setupLabels()
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels() {
        
        labels.forEach({ $0.removeFromSuperview() })
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width/4, height: 40))
            label.text = items[index - 1]
            label.backgroundColor = .clear
            label.textAlignment = .center
             label.font = UIFont(name: "AvenirNext-Bold", size: 13)!
            label.textColor = index == 0 ? selectedLabelColor : unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            labels.append(label)
        }
        
        addConstraints(to: labels, padding: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        
        thumbView.frame = selectFrame
        thumbView.backgroundColor = .lightGray
        
        self.thumbView.frame = labels[selectedIndex].frame
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        var calculatedIndex: Int?
        
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            animateSelectedIndex()
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func animateSelectedIndex() {
        
        let labelFrame = labels[selectedIndex].frame
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [], animations: {
            self.thumbView.frame = labelFrame
            let color: UIColor
            
            switch self.selectedIndex {
            case 1:  color = .birthday
            case 2:  color = .anniversary
            case 3:  color = .holiday
            default: color = .gray
            }
            self.thumbView.backgroundColor = color
        }, completion: nil)
    }
    
    func addConstraints(to items: [UIView], padding: CGFloat) {
        
        for (index, item) in items.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            var rightConstraint: NSLayoutConstraint!
            
            if index == items.count - 1 {
                rightConstraint = NSLayoutConstraint(item: item, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -padding)
            } else {
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: item, attribute: .right, relatedBy: .equal, toItem: nextButton, attribute: .left, multiplier: 1.0, constant: -padding)
            }
            
            var leftConstraint: NSLayoutConstraint!
            
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: item, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: padding)
            } else {
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: item, attribute: .left, relatedBy: .equal, toItem: prevButton, attribute: .right, multiplier: 1.0, constant: padding)
                
                let firstItem = items[0]
                
                let widthConstraint = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: firstItem, attribute: .width, multiplier: 1.0  , constant: 0)
                
                self.addConstraint(widthConstraint)
            }
            
            self.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
}
