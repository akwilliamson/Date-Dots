//
//  UIImageExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/24/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension UIImage {
    
    func imageWithColor(_ tintColor: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        tintColor.setFill()
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
            context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
          context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
