//
//  CircleView.swift
//  Date Dots
//
//  Created by Aaron Williamson on 4/25/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    // MARK: Constant

    private enum Constant {
        static let borderWidth: CGFloat = 4
    }

    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    // MARK: Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height/2
        clipsToBounds = true
    }

    // MARK: Configuration
    
    func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderWidth = Constant.borderWidth
    }
}
