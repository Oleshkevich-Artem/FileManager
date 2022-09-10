//
//  LocalNotificationsService.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 2.07.22.
//

import UIKit
import UserNotifications

class LocalNotificationsService {
    static let shared = LocalNotificationsService()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    private init() { }
    
    func requestNotificationsPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.sendLocalEverydayNotification()
            }
        }
    }

    func sendLocalAfterClosingNotification() {
        let interval = 60
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval),
                                                        repeats: false)
        
        createNotification(title: "Bye!", body: "See you later!", trigger: trigger, id: "afterClosingNotificationID")
    }
    
    private func sendLocalEverydayNotification() {
        var dateComponents = DateComponents()
        dateComponents.hour = 20
    
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: true)
        
        createNotification(title: "Hello!", body: "Don't forget to add new files!", trigger: trigger, id: "EverydayNotificationID")
    }
    
    private func createNotification(title: String, body: String, trigger: UNNotificationTrigger, id: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)

        notificationCenter.add(request) { error in
            if error != nil {
              print("Error")
            }
        }
    }
}
