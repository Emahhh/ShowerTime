import SwiftUI

extension Color {
    static let appBackground = Color("AppBackground")
}

struct ContentView: View {
    
    var body: some View {
        ZStack{
            Color(UIColor.lightGray)
                .ignoresSafeArea()
            TabView {
                // Home Tab
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                // Stats Tab
                StatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.fill")
                    }
                
                // Learn Tab
                LearnView()
                    .tabItem {
                        Label("Learn", systemImage: "book.fill")
                    }
                
                // Settings Tab
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }

            }
        }
    }
}
