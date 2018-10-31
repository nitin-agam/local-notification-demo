//
//  NotificationManager.swift
//  CollectionGridViewDemo
//
//  Created by Nitin A on 30/10/18.
//  Copyright © 2018 Nitin Aggarwal. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

enum AttachmentType {
    case image
    case gif
    case audio
    case video
}

class NotificationManager: NSObject {
    
    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    private let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
    
    override init() {
        super.init()
        self.notificationCenter.delegate = self
    }
    
    func registerNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if error != nil {
                print("Error while registering for notification.")
                return
            }
        }
    }
    
    
    // MARK: - Private Methods
    private func notificationContent(_ subtitle: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Notification"
        content.subtitle = subtitle
        return content
    }
    
    private func addDelayNotification(_ content: UNMutableNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: "timeInterval", content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if error != nil {
                print("Error found while adding notification request")
                return
            }
        }
    }
    
    private func notificationAttachment(fileName: String, type: String) -> UNNotificationAttachment? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: type) {
            if let attachment = try? UNNotificationAttachment(identifier: "attach", url: url, options: nil) {
                return attachment
            }
        }
        return nil
    }
    
    private func setCategories() {
        
        // category 1
        let action1 = UNNotificationAction(identifier: "action1", title: "Auth Required", options: .authenticationRequired)
        let action2 = UNNotificationAction(identifier: "action1", title: "Open App", options: .foreground)
        let category1 = UNNotificationCategory(identifier: "category1", actions: [action1, action2], intentIdentifiers: [], options: [])
        
        // category 2
        let action3 = UNNotificationAction(identifier: "action3", title: "Dismiss Style", options: .destructive)
        let action4 = UNNotificationAction(identifier: "action4", title: "Unlock and Delete", options: [.authenticationRequired, .destructive])
        let category2 = UNNotificationCategory(identifier: "category2", actions: [action3, action4], intentIdentifiers: [], options: [])
        
        
        // category 3
        let action5 = UNTextInputNotificationAction(identifier: "action5", title: "Enter Name", options: .foreground, textInputButtonTitle: "Send", textInputPlaceholder: "Enter here...")
        let category3 = UNNotificationCategory(identifier: "category3", actions: [action5], intentIdentifiers: [], options: [])
        notificationCenter.setNotificationCategories([category1, category2, category3])
    }
    
    
    // MARK: - Default Notifications Methods
    func addNotificationWithTimeInterval() {
        addDelayNotification(notificationContent("Added notification with time interval"), trigger: trigger)
    }
    
    func addNotificationWithCalendar() {
        
        // Note: if you have to test this notification, set components according to your choice. Weekday starts from Sunday = 1.
        var components = DateComponents()
        components.weekday = 3
        components.hour = 15
        components.minute = 55
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        addDelayNotification(notificationContent("Added notification with Calendar"), trigger: trigger)
    }
    
    
    func addNotificationWithLocation() {
        
        // Give location according to you.
        let center = CLLocationCoordinate2D(latitude: 28.5918899, longitude: 77.3170099)
        let region = CLCircularRegion(center: center, radius: 500, identifier: "center")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        addDelayNotification(notificationContent("Added notification with Location"), trigger: trigger)
    }
    
    // MARK: - Attachment Notifications Methods
    func addNotificationWithAttachment(type: AttachmentType) {
        
        switch type {
        case .image:
            let content = self.notificationContent("Added notification with image")
            if let attach = self.notificationAttachment(fileName: "image_1", type: "png") {
                content.attachments = [attach]
            }
            self.addDelayNotification(content, trigger: trigger)
            
        case .gif:
            let content = self.notificationContent("Added notification with gif")
            if let attach = self.notificationAttachment(fileName: "sample_gif", type: "gif") {
                content.attachments = [attach]
            }
            self.addDelayNotification(content, trigger: trigger)
            
        case .audio:
            let content = self.notificationContent("Added notification with Audio")
            if let attach = self.notificationAttachment(fileName: "audio_1", type: "wav") {
                content.attachments = [attach]
            }
            self.addDelayNotification(content, trigger: trigger)
            
        case .video:
            let content = self.notificationContent("Added notification with Video")
            if let attach = self.notificationAttachment(fileName: "small", type: "mp4") {
                content.attachments = [attach]
            }
            self.addDelayNotification(content, trigger: trigger)
        }
    }
    
    
    // MARK: - Category Methods
    func addNotificationForCategory1() {
        setCategories()
        let content = notificationContent("Category 1")
        content.categoryIdentifier = "category1"
        addDelayNotification(content, trigger: trigger)
    }
    
    func addNotificationForCategory2() {
        setCategories()
        let content = notificationContent("Category 2")
        content.categoryIdentifier = "category2"
        addDelayNotification(content, trigger: trigger)
    }
    
    func addNotificationForCategory3() {
        setCategories()
        let content = notificationContent("Category 3")
        content.categoryIdentifier = "category3"
        addDelayNotification(content, trigger: trigger)
    }
    
    func addNotificationForCustomMediaPlayer() {
        let playAction = UNNotificationAction(identifier: "play_action", title: "Play", options: .authenticationRequired)
        let commentAction = UNTextInputNotificationAction(identifier: "comment_action", title: "Enter text", options: .authenticationRequired, textInputButtonTitle: "Send", textInputPlaceholder: "Enter here...")
        let category = UNNotificationCategory(identifier: "categoryCustomUI", actions: [playAction, commentAction], intentIdentifiers: [], options: [.customDismissAction])
        notificationCenter.setNotificationCategories([category])
        
        let content = notificationContent("This notification sent using Category.")
        content.categoryIdentifier = "categoryCustomUI"
        if let attach = self.notificationAttachment(fileName: "small", type: "mp4") {
            content.attachments = [attach]
        }
        addDelayNotification(content, trigger: trigger)
    }
    
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    // Calls when a notification will be display when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    // Calls when a notification will be clicked when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
