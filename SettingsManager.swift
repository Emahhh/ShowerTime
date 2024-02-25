import SwiftUI;

class SettingsManager: ObservableObject {
    /// Singleton instance
    static let shared = SettingsManager()
    private init() {}

    @AppStorage("maxShowerTime") var maxShowerTime: Int = 1
    @AppStorage("litersPerMinute") var litersPerMinute: Int = 19
    @AppStorage("gracePeriod") var gracePeriod: Int = 15

    /// Resets settings to default
    func resetSettings() {
        // TODO: put the real default vaues as in the UI
        maxShowerTime = 1*60
        litersPerMinute = 19
        
        /// some additional seconds to give the user time to press "end", even if the time has run out
        gracePeriod = 15
    }
}
