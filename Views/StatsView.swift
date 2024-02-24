import SwiftUI

struct StatsView: View {
    @ObservedObject var myStats = UserStats.shared
    
    var body: some View {
        ZStack {
            Color.appBackground
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                if myStats.totalShowers > 0 {
                    Text("Your shower stats")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)
                    
                    GeometryReader { geometry in
                        VStack {
                            StatCard(subtitle: "Liters you consume on average per shower", value: "\(myStats.averageLitersConsumed)L on average")
                            StatCard(subtitle: "Liters you saved overall by using this app", value: "\(myStats.totalLitersSaved)L saved")
                            StatCard(subtitle: "Times you ended your shower on time", value: "\(myStats.totalTimesWon) wins")
                            StatCard(subtitle: "Current streak of wins", value: "Streak of \(myStats.streak)")
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                }else {
                    Text("Track your first shower to see some stats here!")
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                        .padding()
                }

                
                Button(action: {
                    shareChallenge()
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Challenge Friends")
                            .bold()
                    }
                }
                .buttonStyle(GradientButtonStyle())
                .padding()
            }
            .padding(20) // Adjust outer padding
        }
    }
    
    
    
    /// Share a text using a UIActivityViewController
    func shareChallenge() {
        let challengeText = "I saved \(myStats.totalLitersSaved) liters of water so far thanks to this application. Do you think you could do better? Download ShowerTime to find out!"
        
        let activityViewController = UIActivityViewController(activityItems: [challengeText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    
}

struct StatCard: View {
    var subtitle: String
    var value: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.white)
            .shadow(radius: 2)
            .overlay(
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(value)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer() // Push VStack to the leading edge
                }
                .padding(20)
            )
            .padding()
    }

}

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .shadow(radius: 4)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
