//
//  NotificationManager.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/6/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import Foundation
import UserNotifications

/// Encapsulates all relevant errors related to notifications.
enum NotificationError: Error {
    /// Invitation to enable notifications has been declined
    case accessDenied
    /// Notifications are disabled
    case denied
    /// Unknown error has occured
    case unknown
    /// No notification was found
    case notificationNotFound
    /// Failed to schedule notification
    case schedulingFailed
}

class NotificationManager {
    
    // MARK: TypeAliases
    
    typealias AuthorizationStatusResult = Result<Bool, NotificationError>
    typealias AuthorizationRequestResult = Result<Bool, NotificationError>
    typealias RetrieveNotificationResult = Result<UNNotificationRequest, NotificationError>
    typealias ScheduleNotificationResult = Result<UNNotificationRequest, NotificationError>
    typealias RemoveNotificationResult = Result<Bool, NotificationError>
    
    // MARK: Properties
    
    /// All scheduled `Event` notifications.
    private var notifications: [UNNotificationRequest] = []
    
    // MARK: Initialization
    
    init() {
        getNotifications()
    }
    
    // MARK: Public Interface
    
    /// Retrieves an on-device scheduled notification for a given ID.
    func retrieveNotification(for id: String, completion: @escaping (RetrieveNotificationResult) -> ()) {
        if let match = notifications.first(where: { $0.identifier == id }) {
            completion(.success(match))
        } else {
            completion(.failure(NotificationError.notificationNotFound))
        }
    }
    
    /// Schedules an on-device notification for a set of reminder details.
    func scheduleNotification(reminder: Reminder, completion: @escaping (ScheduleNotificationResult) -> ()) {
        getAuthorizationStatus { result in
            switch result {
            case .success:
                self.addNotification(reminder: reminder) { result in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Removes an on-device scheduled notification for a given ID.
    func removeNotification(with id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    // MARK: Private Helpers
    
    /// Retrieves and stores all scheduled on-device notifications.
    private func getNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            self.notifications = notifications
        }
    }
    
    /// Retrieves the permission status to send on-device notifications, and requests permission if necessary.
    private func getAuthorizationStatus(completion: @escaping (AuthorizationStatusResult) -> ()) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                completion(.success(true))
            case .denied:
                completion(.failure(NotificationError.denied))
            case .ephemeral:
                completion(.failure(NotificationError.denied))
            case .notDetermined:
                self.requestAuthorization { result in
                    completion(result)
                }
            case .provisional:
                completion(.success(true))
            @unknown default:
                completion(.failure(NotificationError.unknown))
            }
        }
    }
    
    /// Requests permission to send on-device notifications.
    private func requestAuthorization(completion: @escaping (AuthorizationRequestResult) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (success, error) in
            if success {
                completion(.success(true))
            } else {
                completion(.failure(NotificationError.accessDenied))
            }
        }
    }
    
    /// Adds a new on-device scheduled notification to the user notification center.
    private func addNotification(reminder: Reminder, completion: @escaping (ScheduleNotificationResult) -> ()) {
        // Delete any pre-existing local notification if it exists
        removeNotification(with: reminder.id)
        
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = reminder.body

        let notificationRequest = UNNotificationRequest(
            identifier: reminder.id,
            content: content,
            trigger: UNCalendarNotificationTrigger(
                dateMatching: reminder.fireDate,
                repeats: false
            )
        )
        
        UNUserNotificationCenter.current().add(notificationRequest) { error in
            if error == nil {
                completion(.success(notificationRequest))
            } else {
                completion(.failure(NotificationError.schedulingFailed))
            }
        }
    }
}
