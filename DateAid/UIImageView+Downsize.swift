//
//  UIImageView+Downsize.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/5/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func downsizeImage(to size: CGSize) {
        image = UIGraphicsImageRenderer(size: size).image { (context) in
            image?.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
