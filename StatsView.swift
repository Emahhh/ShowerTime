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

                }
            }
            
            
        }

    }
}

#Preview {
    StatsView()
}
