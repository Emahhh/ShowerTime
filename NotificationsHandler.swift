
import Foundation

import UserNotifications


// Schedule a local notification
func scheduleNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Shower Reminder"
    content.body = "Your shower is approaching its end. Save water!"
    content.sound = UNNotificationSound.default

    // Set the trigger for the notification
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 5, repeats: false) // 5 minutes before the end

    // Create the request
    let request = UNNotificationRequest(identifier: "showerReminder", content: content, trigger: trigger)

    // Schedule the notification
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}

