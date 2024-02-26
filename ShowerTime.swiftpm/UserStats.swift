import Foundation
import SwiftUI


class UserStats: ObservableObject {
    
    
    @AppStorage("averageLitersConsumed") var averageLitersConsumed: Int = 0
    @AppStorage("totalShowers") var totalShowers: Int = 0
    @AppStorage("totalTimesWon") var totalTimesWon: Int = 0
    @AppStorage("totalLitersSaved") var totalLitersSaved: Int = 0
    @AppStorage("streak") var streak : Int = 0
    
    /// Singleton instance
    static let shared = UserStats()
    
    /// private initializer to prevent instantiation
    private init() {}
    
    
    /// save a new completed shower updating the statistics
    func saveNewShower(isWon: Bool, litersConsumed: Int, litersSaved: Int) {
        totalShowers += 1
        if isWon {
            totalTimesWon += 1
            streak += 1
        } else {
            streak = 0
        }
        
        if totalShowers > 0 {
            averageLitersConsumed = (averageLitersConsumed * (totalShowers - 1) + litersConsumed) / totalShowers
        } else {
            averageLitersConsumed = litersConsumed
        }
        
        totalLitersSaved += litersSaved
    }
    
    
    func resetStats() {
        averageLitersConsumed = 0
        totalShowers = 0
        totalTimesWon = 0
        totalLitersSaved = 0
        streak = 0
    }
}
