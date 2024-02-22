import SwiftUI;

class ShowerSettingsManager: ObservableObject {
    /// Singleton instance
    static let shared = ShowerSettingsManager()
    private init() {}

    @AppStorage("maxShowerTime") var maxShowerTime: Int = 15
    @AppStorage("litersPerMinute") var litersPerMinute: Int = 10
    @AppStorage("gracePeriod") var gracePeriod: Int = 5

    // Reset settings function
    func resetSettings() {
        maxShowerTime = 10
        litersPerMinute = 8
        gracePeriod = 4
    }
}
