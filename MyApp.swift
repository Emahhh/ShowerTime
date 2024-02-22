import SwiftUI


@main
struct MyApp: App {
    // Request notification authorization in the init method
     init() {
         requestNotificationAuthorization()
     }

     var body: some Scene {
         WindowGroup {
             ContentView()
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
