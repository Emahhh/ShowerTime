import SwiftUI

extension Color {
    static let appBackground = Color("AppBackground")
}

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack{
            Color(UIColor.lightGray)
                .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                // Home Tab
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                // Stats Tab
                StatsView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Stats")
                    }
                    .tag(1)
                
                // Learn Tab
                LearnView()
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Learn")
                    }
                    .tag(2)
                
                // Settings Tab
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                    .tag(3)
            }
        }
    }
}
