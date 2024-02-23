import Foundation

import UserNotifications


class NotificationDelegate: ObservableObject {
    /// Schedule a local notification
    ///
    /// Note: the notification is delivered only when the app is NOT in the foreground
    func scheduleNotification() {
        print("Scheduling notification...");
        
        let content = UNMutableNotificationContent()
        content.title = "Shower Reminder"
        content.body = "Your shower is approaching its end. Save water!"
        content.sound = UNNotificationSound.default

        // Set the trigger for the notification
        // TODO: trigger it in the right moment (maybe take a timestamp as parameter)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // 1 second

        // Create the request
        let request = UNNotificationRequest(identifier: "showerReminder", content: content, trigger: trigger)

        // Schedule the notification
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    // Cancel the scheduled notification
    func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["showerReminder"])
    }
}
