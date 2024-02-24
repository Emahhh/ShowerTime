import SwiftUI;

class SettingsManager: ObservableObject {
    /// Singleton instance
    static let shared = SettingsManager()
    private init() {}

    @AppStorage("maxShowerTime") var maxShowerTime: Int = 15
    @AppStorage("litersPerMinute") var litersPerMinute: Int = 10
    @AppStorage("gracePeriod") var gracePeriod: Int = 5

    /// Resets settings to default
    func resetSettings() {
        // TODO: put the real default vaues as in the UI
        maxShowerTime = 10
        litersPerMinute = 8
        
        /// some additional seconds to give the user time to press "end", even if the time has run out
        gracePeriod = 30
    }
}
