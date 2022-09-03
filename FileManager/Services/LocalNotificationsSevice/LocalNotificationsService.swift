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
    
    private init() {}
    
    func requestNotificationsPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.sendLocalNotificationEveryday()
            }
        }
    }
        
    func sendLocalNotificationAfterClosingApp() {
        let interval = 10
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval),
                                                        repeats: true)
        
        createLocalNotification(title: "Bye!", body: "See your latter!", trigger: trigger, id: "afterClosingLocalNotificationID")
    }
    
    private func sendLocalNotificationEveryday() {
        var dateComponents = DateComponents()
        dateComponents.hour = 11
        dateComponents.minute = 26
    
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: true)
        
        createLocalNotification(title: "Hi!", body: "Don't forget about as!", trigger: trigger, id: "EverydayNotificationID")
    }
    
    private func createLocalNotification(title: String, body: String, trigger: UNNotificationTrigger, id: String) {
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
