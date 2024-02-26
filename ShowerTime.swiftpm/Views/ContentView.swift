import SwiftUI

extension Color {
    static let appBackground = Color("AppBackground")
}

struct ContentView: View {


    @ObservedObject var currShower = Shower.shared

    @State private var showAlert = false
    @State private var selectedTab = 0
    @State private var previousTab = 0

    var body: some View {
        ZStack {
            Color(UIColor.lightGray)
                .ignoresSafeArea()

            TabView(selection: $selectedTab) {
                // Home Tab
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)

                // Stats Tab
                StatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.fill")
                    }
                    .tag(1)

                // Learn Tab
                LearnView()
                    .tabItem {
                        Label("Learn", systemImage: "book.fill")
                    }
                    .tag(2)

                // Settings Tab
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(3)
            }
            .onChange(of: selectedTab) { newValue in
                // check if the shower timer is running: in that case prevent the user from switching tabs
                if currShower.isRunning {
                    selectedTab = previousTab // Prevent tab switch by going back
                    showAlert = true // Show alert
                } else {
                    previousTab = newValue
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("End Your Shower First! 🛑⏰"), message: Text("You have a timer running. Please end it before switching tabs."), dismissButton: .default(Text("OK")))
            }
        }
    }
}
