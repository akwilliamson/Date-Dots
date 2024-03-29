//
//  UIDevice+Type.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

public extension UIDevice {

    static var type: DeviceModel {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }

        let deviceModelMap : [String: DeviceModel] = [

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
            "iPhone12,8": .iPhoneSE2,
            "iPhone13,1": .iPhone12Mini,
            "iPhone13,2": .iPhone12,
            "iPhone13,3": .iPhone12Pro,
            "iPhone13,4": .iPhone12ProMax,
            "iPhone14,2": .iPhone13Pro,
            "iPhone14,3": .iPhone13ProMax,
            "iPhone14,4": .iPhone13Mini,
            "iPhone14,5": .iPhone13,
            "iPhone14,6": .iPhoneSE3,
        ]

        guard let existingModelCode = modelCode, let modelValue = String.init(validatingUTF8: existingModelCode) else {
            return .unrecognized
        }
        
        if let model = deviceModelMap[modelValue] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = deviceModelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }

        return .unrecognized
    }
}
