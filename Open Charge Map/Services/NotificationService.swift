//
//  NotificationService.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import Foundation
import UserNotifications

protocol NotificationServices {
    func requestNotification(message: String, title: String, subtitle: String)
    func requestAuthorization()
    var wasSetByUser: Bool { get set }
}

class NotificationService: NotificationServices {
    
    static let shared: NotificationService = NotificationService()
    internal var wasSetByUser: Bool = false
    
    private init() {
        self.requestAuthorization()
    }
    
    func requestNotification(message: String, title: String, subtitle: String) {
        debugPrint("Requesting notification")
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = message
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                debugPrint("All set!")
            } else if let error = error {
                self.wasSetByUser = true
                debugPrint(error)
            }
        }
    }
}
