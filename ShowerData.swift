import SwiftUI

class ShowerData: ObservableObject {
    @Published var startTime: Date?
    @Published var endTime: Date?
    @Published var showerDuration: Int = 0
    @Published var litersConsumed: Int = 0
    @Published var won: Bool = false;
}


