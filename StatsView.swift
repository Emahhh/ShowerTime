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
                    Text("You won \(UserStatistics.totalTimesWon) times so far.")
                    Text("Consumed an average of \(UserStatistics.averageLitersConsumed) L.")
                    Text("Saved \(UserStatistics.totalLitersSaved) L.")
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
