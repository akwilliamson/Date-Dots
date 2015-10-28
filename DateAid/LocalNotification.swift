//
//  LocalNotification.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/28/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

struct LocalNotification {
    
    var fireDate: NSDate?
    var repeatInterval: NSCalendarUnit?
    var alertBody: String?
    var alertAction: String?
    var soundName: String?
    
    var userInfo: [String: String]
    
    init(fireDate: NSDate, repeatInterval: NSCalendarUnit?, alertBody: String, alertAction: String, soundName: String, userInfo: [String: String]) {
        self.fireDate = fireDate
        self.repeatInterval = repeatInterval
        self.alertBody = alertBody
        self.alertAction = alertAction
        self.soundName = soundName
        self.userInfo = userInfo
    }
    
    func schedule() {
        let localNotification = UILocalNotification()
        localNotification.fireDate = self.fireDate
        if let repeatInterval = repeatInterval {
            localNotification.repeatInterval = repeatInterval
        }
        localNotification.alertBody = self.alertBody
        localNotification.alertAction = self.alertAction
        localNotification.soundName = self.soundName
        localNotification.userInfo = self.userInfo
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
}