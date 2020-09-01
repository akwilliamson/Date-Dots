//
//  Font.swift
//  DateAid
//
//  Created by Aaron Williamson on 8/2/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

enum FontType {
    
    case avenirNextBold(CGFloat)
    case avenirNextDemiBold(CGFloat)
    case avenirNextMedium(CGFloat)
    case noteworthyBold(CGFloat)
    
    var font: UIFont {
        switch self {
        case .avenirNextBold(let size):
            return UIFont(name: "AvenirNext-Bold", size: size)!
        case .avenirNextDemiBold(let size):
            return UIFont(name: "AvenirNext-DemiBold", size: size)!
        case .avenirNextMedium(let size):
            return UIFont(name: "AvenirNext-Medium", size: size)!
        case .noteworthyBold(let size):
            return UIFont(name: "Noteworthy-Bold", size: size)!
        }
    }
}
