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
                    Text("You won \(UserStats.totalTimesWon) times so far.")
                    Text("Consumed an average of \(UserStats.averageLitersConsumed) L.")
                    Text("Saved \(UserStats.totalLitersSaved) L.")
                    Text("On a streak of \(UserStats.streak) days.")

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
