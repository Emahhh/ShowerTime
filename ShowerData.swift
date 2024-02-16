import SwiftUI

class ShowerData: ObservableObject {
    @Published var startTime: Date?
    @Published var endTime: Date?
    @Published var litersConsumed: Int = 0
}

// Constants
struct Constants {
    static let maxShowerTime: TimeInterval = 10 * 60 // 10 minutes
}
