import UserNotifications

class NotificationDelegate: ObservableObject {
    
    /// Cancels the (only?) scheduled notification
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// Schedules an "end your shower" notifications that will be fired in `inSeconds` seconds
    func scheduleNotification(inSeconds: Int) {
        guard inSeconds > 0 else {
            print("not sending the notification bc inSeconds <= 0")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Shower Reminder"
        content.body = "Time to end your shower!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("tyla_water.mp3"))

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(inSeconds), repeats: false)

        let request = UNNotificationRequest(identifier: "showerNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
        print("Scheduled a notification that will be fired in \(inSeconds) seconds")
    }
}
