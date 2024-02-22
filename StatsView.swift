import SwiftUI

struct StatsView: View {
    

    @ObservedObject var myStats = UserStats.shared;
    
    var body: some View {
        ZStack {
            Color.appBackground
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Hello, Stats!")
                VStack {
                    Text("You won \(myStats.totalTimesWon) times so far.")
                    Text("Consumed an average of \(myStats.averageLitersConsumed) L.")
                    Text("Saved \(myStats.totalLitersSaved) L.")
                    Text("On a streak of \(myStats.streak) days.")
                    
                    Button("Challenge Friends") {
                        shareChallenge()
                    }

                }
                
                
                
            }
            
            
        }

    }
    
    func shareChallenge() {
        let challengeText = "I saved \(myStats.totalLitersSaved) liters of water so far thanks to this application. Do you think you could do better? Download ShowerTime to find out!"
        
        let activityViewController = UIActivityViewController(activityItems: [challengeText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
}

#Preview {
    StatsView()
}
