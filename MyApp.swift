import SwiftUI


@main
struct MyApp: App {
    @StateObject private var notificationDelegate = NotificationDelegate()

    
     init() {
         requestNotificationAuthorization()
     }

     var body: some Scene {
         WindowGroup {
             ContentView()
                 .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                                    // App is about to enter foreground
                                    notificationDelegate.cancelNotification()
                                }
                                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                                    // App entered background
                                    notificationDelegate.scheduleNotification()
                                }
         }
     }
    
    

     // Function to request notification authorization
     private func requestNotificationAuthorization() {
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
             // Handle authorization status
             if granted {
                 print("Notification authorization granted")
             } else {
                 print("Notification authorization denied")
             }
         }
     }
}
