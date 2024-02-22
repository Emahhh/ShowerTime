import SwiftUI

struct StatsView: View {
    
    @State private var refreshCount = 0
    
    
    var body: some View {
        ZStack {
            Color.appBackground
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Hello, Stats!")
                VStack {
                    Text("You won \(myUserStats.totalTimesWon) times so far.")
                    Text("Consumed an average of \(myUserStats.averageLitersConsumed) L.")
                    Text("Saved \(myUserStats.totalLitersSaved) L.")
                    Text("On a streak of \(myUserStats.streak) days.")

                }
            }.id(refreshCount)
            
            
        }
        .onAppear {
            refreshCount += 1
        }
    }
}

#Preview {
    StatsView()
}
