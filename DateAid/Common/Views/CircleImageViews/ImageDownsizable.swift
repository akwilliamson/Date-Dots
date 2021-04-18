//
//  ImageDownsizable.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

/// Contains the capability to downsize a `UIImage`.
protocol ImageDownsizable: class {
    
    var image: UIImage? { get set }
    
    /// Downsizes the image to a given size.
    func downsizeImage(to size: CGSize)
}

extension ImageDownsizable {
    
    func downsizeImage(to size: CGSize) {
        image = UIGraphicsImageRenderer(size: size).image { _ in
            let rect = CGRect(origin: .zero, size: size)
            image?.draw(in: rect)
        }
    }
}
