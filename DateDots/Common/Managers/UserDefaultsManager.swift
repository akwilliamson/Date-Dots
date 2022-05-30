//
//  UserDefaultsManager.swift
//  DateDots
//
//  Created by Aaron Williamson on 5/28/22.
//  Copyright © 2022 Aaron Williamson. All rights reserved.
//

import Foundation

enum UserDefaultsKey: String {
    
    // MARK: Counts
    
    case countAppReview    = "count.appReview"
    case countEventSave    = "count.saveEvent"
    case countReminderSave = "count.saveReminder"
    
    // MARK: Displays
    
    case displayInfo = "display.info"
    case displayNote = "display.note"
    
    // MARK: Filters
    
    case filterEvent = "filter.event"
    case filterNote  = "filter.note"
    
    // MARK: Times
    
    case timeSinceLastPrompt = "time.sinceLastPrompt"
}

class UserDefaultsManager {
    
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func getTime(for key: UserDefaultsKey) -> Date? {
        let date = userDefaults.object(forKey: key.rawValue) as? Date

        return date
    }
    
    func setTime(_ time: Date, for key: UserDefaultsKey) {
        let customKey = "\(key.rawValue)"
        
        userDefaults.set(Date(), forKey: customKey)
    }
    
    func getInt(for key: UserDefaultsKey) -> Int {
        let customKey = "\(key.rawValue)"

        return userDefaults.integer(forKey: customKey)
    }
    
    func bumpInt(for key: UserDefaultsKey) {
        guard var value = userDefaults.value(forKey: key.rawValue) as? Int else {
            userDefaults.set(1, forKey: key.rawValue); return
        }
        
        value += 1
        
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func getBool(type: String, for key: UserDefaultsKey) -> Bool {
        let customKey = "\(key.rawValue).\(type)"
        
        return userDefaults.bool(forKey: customKey)
    }
    
    func setBool(_ bool: Bool, type: String, for key: UserDefaultsKey) {
        let customKey = "\(key.rawValue).\(type)"
        
        userDefaults.set(bool, forKey: customKey)
    }
    
    // Migrate old keys to new keys, remove when analytics show zero cases happening
    func migrateOldKeys() {
        // An old key must exist to signify that old keys still need to be removed
        guard userDefaults.object(forKey: "eventdetails-info-reminder") != nil else { return }
        
        let value1 = userDefaults.bool(forKey: "eventdetails-info-reminder")
        setBool(value1, type: "reminder", for: .displayInfo)
        userDefaults.removeObject(forKey: "eventdetails-info-reminder")
        
        let value2 = userDefaults.bool(forKey: "eventdetails-info-address")
        setBool(value2, type: "address", for: .displayInfo)
        userDefaults.removeObject(forKey: "eventdetails-info-address")
        
        let value3 = userDefaults.bool(forKey: "eventdetails-note-gifts")
        setBool(value3, type: "gifts", for: .displayNote)
        userDefaults.removeObject(forKey: "eventdetails-note-gifts")
        
        let value4 = userDefaults.bool(forKey: "eventdetails-note-plans")
        setBool(value4, type: "plans", for: .displayNote)
        userDefaults.removeObject(forKey: "eventdetails-note-plans")
        
        let value5 = userDefaults.bool(forKey: "eventdetails-note-misc")
        setBool(value5, type: "misc", for: .displayNote)
        userDefaults.removeObject(forKey: "eventdetails-note-misc")
        
        
        
        let value6 = userDefaults.bool(forKey: "note-gifts")
        setBool(value6, type: "gifts", for: .filterNote)
        userDefaults.removeObject(forKey: "note-gifts")
        
        let value7 = userDefaults.bool(forKey: "note-plans")
        setBool(value7, type: "plans", for: .filterNote)
        userDefaults.removeObject(forKey: "note-plans")
        
        let value8 = userDefaults.bool(forKey: "note-misc")
        setBool(value8, type: "misc", for: .filterNote)
        userDefaults.removeObject(forKey: "note-misc")
        
        
        
        let value9 = userDefaults.bool(forKey: "event-birthday")
        setBool(value9, type: "birthday", for: .displayNote)
        userDefaults.removeObject(forKey: "event-birthday")
        
        let value10 = userDefaults.bool(forKey: "event-anniversary")
        setBool(value10, type: "anniversary", for: .displayNote)
        userDefaults.removeObject(forKey: "event-anniversary")
        
        
        let value11 = userDefaults.bool(forKey: "event-custom")
        setBool(value11, type: "custom", for: .displayNote)
        userDefaults.removeObject(forKey: "event-custom")
    }
}
