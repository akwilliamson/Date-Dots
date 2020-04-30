//
//  CircleLabel.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/25/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class CircleLabel: UILabel {

    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    // MARK: Lifecycle
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        clipsToBounds = true
        layer.cornerRadius = bounds.width/2
    }

    // MARK: View Setup
    
    private func configureView() {
        numberOfLines = 0
        textAlignment = .center
        clipsToBounds = true
    }
}
