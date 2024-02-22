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
    var averageLitersConsumed: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaults.Keys.averageLitersConsumed)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.averageLitersConsumed)
        }
    }
    
    var totalShowers: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaults.Keys.totalShowers)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.totalShowers)
        }
    }
    
    var totalTimesWon: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaults.Keys.totalTimesWon)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.totalTimesWon)
        }
    }
    
    var totalLitersSaved: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaults.Keys.totalLitersSaved)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.totalLitersSaved)
        }
    }
    
    // Function to save new shower statistics
    func saveNewShower(isWon: Bool, litersConsumed: Int, litersSaved: Int) {
        totalShowers += 1
        if isWon {
            totalTimesWon += 1
        }
        averageLitersConsumed = (averageLitersConsumed * (totalShowers - 1) + litersConsumed) / totalShowers
        totalLitersSaved += litersSaved
    }
}
