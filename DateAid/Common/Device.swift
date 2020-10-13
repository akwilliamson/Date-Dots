//
//  Device.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/12/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

public enum Model: String {

    case simulator      = "simulator/sandbox"
    case iPhone4        = "iPhone 4"
    case iPhone4S       = "iPhone 4S"
    case iPhone5        = "iPhone 5"
    case iPhone5S       = "iPhone 5S"
    case iPhone5C       = "iPhone 5C"
    case iPhone6        = "iPhone 6"
    case iPhone6Plus    = "iPhone 6 Plus"
    case iPhone6S       = "iPhone 6S"
    case iPhone6SPlus   = "iPhone 6S Plus"
    case iPhoneSE       = "iPhone SE"
    case iPhone7        = "iPhone 7"
    case iPhone7Plus    = "iPhone 7 Plus"
    case iPhone8        = "iPhone 8"
    case iPhone8Plus    = "iPhone 8 Plus"
    case iPhoneX        = "iPhone X"
    case iPhoneXS       = "iPhone XS"
    case iPhoneXSMax    = "iPhone XS Max"
    case iPhoneXR       = "iPhone XR"
    case iPhone11       = "iPhone 11"
    case iPhone11Pro    = "iPhone 11 Pro"
    case iPhone11ProMax = "iPhone 11 Pro Max"
    case iPhoneSE2      = "iPhone SE 2nd gen"
    case unrecognized   = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {

    static var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }

        let modelMap : [String: Model] = [

            //Simulator
            "i386":       .simulator,
            "x86_64":     .simulator,
            "iPhone3,1":  .iPhone4,
            "iPhone3,2":  .iPhone4,
            "iPhone3,3":  .iPhone4,
            "iPhone4,1":  .iPhone4S,
            "iPhone5,1":  .iPhone5,
            "iPhone5,2":  .iPhone5,
            "iPhone5,3":  .iPhone5C,
            "iPhone5,4":  .iPhone5C,
            "iPhone6,1":  .iPhone5S,
            "iPhone6,2":  .iPhone5S,
            "iPhone7,1":  .iPhone6Plus,
            "iPhone7,2":  .iPhone6,
            "iPhone8,1":  .iPhone6S,
            "iPhone8,2":  .iPhone6SPlus,
            "iPhone8,4":  .iPhoneSE,
            "iPhone9,1":  .iPhone7,
            "iPhone9,3":  .iPhone7,
            "iPhone9,2":  .iPhone7Plus,
            "iPhone9,4":  .iPhone7Plus,
            "iPhone10,1": .iPhone8,
            "iPhone10,4": .iPhone8,
            "iPhone10,2": .iPhone8Plus,
            "iPhone10,5": .iPhone8Plus,
            "iPhone10,3": .iPhoneX,
            "iPhone10,6": .iPhoneX,
            "iPhone11,2": .iPhoneXS,
            "iPhone11,4": .iPhoneXSMax,
            "iPhone11,6": .iPhoneXSMax,
            "iPhone11,8": .iPhoneXR,
            "iPhone12,1": .iPhone11,
            "iPhone12,3": .iPhone11Pro,
            "iPhone12,5": .iPhone11ProMax,
            "iPhone12,8": .iPhoneSE2
        ]

        guard let existingModelCode = modelCode, let modelValue = String.init(validatingUTF8: existingModelCode) else {
            return .unrecognized
        }
        
        if let model = modelMap[modelValue] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }

        return .unrecognized
    }
}
