import SwiftUI

class ShowerData: ObservableObject {
    @Published var startTime: Date?
    @Published var endTime: Date?
    @Published var litersConsumed: Int = 0
}


struct ShowerSettings {
    var maxShowerTime: TimeInterval = 10 * 60 // 10 minutes
    
    // TODO: quando inzializzi l'app chiedere che tipo di shower head hai - efficient o no? x sapere quanto consuma
    // the flow rate that represents how much water is consumed per minute
    var litersPerMinute: Int = 10;
}
