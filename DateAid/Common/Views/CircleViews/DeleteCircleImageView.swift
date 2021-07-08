//
//  DeleteCircleImageView.swift
//  DateAid
//
//  Created by Aaron Williamson on 7/7/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class DeleteCircleImageView: CircleImageView {
    
    // MARK: Constant
    
    private enum Constant {
        static let borderWidth: CGFloat = 3
    }
    
    // MARK: Properties
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()
        configureView()
    }
    
    // MARK: View Setup
    
    override func configureView() {
        super.configureView()
        isUserInteractionEnabled = true
        image = UIImage(named: "delete")?.withTintColor(.white)
        layer.borderWidth = Constant.borderWidth
        layer.borderColor = UIColor.white.cgColor
    }
}
