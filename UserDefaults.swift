import Foundation

extension UserDefaults {
    enum Keys {
        static let averageLitersConsumed = "averageLitersConsumed"
        static let totalShowers = "totalShowers"
        static let totalTimesWon = "totalTimesWon"
        static let totalLitersSaved = "totalLitersSaved"
    }
}


class UserStatistics {
    
    // Properties to store user statistics
    static var averageLitersConsumed: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaults.Keys.averageLitersConsumed)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.averageLitersConsumed)
        }
    }
    
    static var totalShowers: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaults.Keys.totalShowers)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.totalShowers)
        }
    }
    
    static var totalTimesWon: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaults.Keys.totalTimesWon)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.totalTimesWon)
        }
    }
    
    static var totalLitersSaved: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaults.Keys.totalLitersSaved)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.totalLitersSaved)
        }
    }
    
    /// save a new completed shower updating the statistics
    static func saveNewShower(isWon: Bool, litersConsumed: Int, litersSaved: Int) {
        totalShowers += 1
        if isWon {
            totalTimesWon += 1
        }
        averageLitersConsumed = (averageLitersConsumed * (totalShowers - 1) + litersConsumed) / totalShowers
        totalLitersSaved += litersSaved
    }
}
