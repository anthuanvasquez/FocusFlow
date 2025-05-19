import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()

    private init() {
        requestAuthorization()
    }

    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }

    func scheduleTimerNotification(for activity: Activity, timeRemaining: TimeInterval, isBreak: Bool) {
        let content = UNMutableNotificationContent()
        content.title = isBreak ? "Break Time!" : "Focus Time!"
        content.body = isBreak ? "Time to take a break" : "Time to focus on: \(activity.name)"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeRemaining, repeats: false)
        let request = UNNotificationRequest(
            identifier: "timer-\(activity.id)",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    func scheduleBreakEndNotification(timeRemaining: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Break's Over!"
        content.body = "Time to get back to work"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeRemaining, repeats: false)
        let request = UNNotificationRequest(
            identifier: "break-end",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }

    func cancelTimerNotification(for activityId: UUID) {
        center.removePendingNotificationRequests(withIdentifiers: ["timer-\(activityId)"])
    }
}
