//
//  NotificationManager.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/6/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationDetails {
    var id: String
    var title: String
    var body: String
    var daysBefore: Int
    var dateComponents: DateComponents
}

class NotificationManager {
    
    private enum Constant {
        enum Key {
            static let daysBefore = "DaysBefore"
        }
    }
    
    // MARK: Properties
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private var notificationRequest: UNNotificationRequest?
    
    // MARK: Private Interface
    
    private func storedNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        notificationCenter.getPendingNotificationRequests { notifications in
            completion(notifications)
        }
    }
    
    // MARK: Initialiation
    
    init() {}
    
    init(notificationRequest: UNNotificationRequest?) {
        self.notificationRequest = notificationRequest
    }
    
    // MARK: Public Interface
    
    var notificationExists: Bool {
        return notificationRequest != nil
    }
    
    func getNotificationRequest() -> UNNotificationRequest? {
        return notificationRequest
    }
    
    func setNotificationRequest(_ notificationRequest: UNNotificationRequest) {
        self.notificationRequest = notificationRequest
    }
    
    func clearNotificationRequest() {
        self.notificationRequest = nil
    }
    
    func notification(with notificationId: String, completion: @escaping (UNNotificationRequest?) -> Void) {
        DispatchQueue.main.async {
            self.storedNotifications { existingNotifications in
                self.notificationRequest = existingNotifications.first(where: { $0.identifier == notificationId })
                completion(self.notificationRequest)
            }
        }
    }

    func scheduleNotification(with details: NotificationDetails, completion: @escaping (UNNotificationRequest) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = details.title
        content.body = details.body
        content.userInfo = [Constant.Key.daysBefore: details.daysBefore]

        let trigger = UNCalendarNotificationTrigger(dateMatching: details.dateComponents, repeats: false)

        let notificationRequest = UNNotificationRequest(identifier: details.id, content: content, trigger: trigger)
        notificationCenter.add(notificationRequest)
        completion(notificationRequest)
    }
    
    func requestPermission(completion: @escaping (Bool, Error?) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert]) { (success, error) in
            completion(success, error)
        }
    }
    
    func cancelNotificationWith(identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func valueFor<T>(key: String) -> T? {
        return notificationRequest?.content.userInfo[key] as? T
    }
    
    func triggerTime() -> Date? {
        let trigger = notificationRequest?.trigger as? UNCalendarNotificationTrigger
        return trigger?.nextTriggerDate()
    }
    
    func permissionStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
}
