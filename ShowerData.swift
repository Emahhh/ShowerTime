import SwiftUI

class ShowerData: ObservableObject {
    @Published var startTime: Date?
    @Published var endTime: Date?
    @Published var showerDuration: Int = 0
    @Published var litersConsumed: Int = 0
    @Published var won: Bool = false;
}


struct ShowerSettings {
    /// maximum number of seconds that the user can spend in the shower in order to win
    var maxShowerTime: Int = 15;
    
    // TODO: quando inzializzi l'app chiedere che tipo di shower head hai - efficient o no? x sapere quanto consuma
    /// the flow rate that represents how much water is consumed per minute, to give an extimation
    var litersPerMinute: Int = 10;
    
    /// number of seconds in which the user has to stop the shower before it is considered as a loss
    var gracePeriod : Int = 5;
}
