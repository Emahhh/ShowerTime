import Foundation

struct WaterMessage: Codable {
    let text: String
    let divideBy: Double
    let minLiters: Double
}

class WaterMessagesManager {
    private let messages: [WaterMessage]

    init?() {
        if let path = Bundle.main.path(forResource: "water_messages", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                self.messages = try decoder.decode([String: [WaterMessage]].self, from: data)["messages"] ?? []
            } catch {
                print("Error loading water messages: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    /// returns a custom message based on the water_messages.json provided.
    ///
    /// It personalizes that message by replacing * with the right amount.
    ///
    /// It doesnt pick a certain message if forLiters is less than minLiters
    func getWaterMessage(forLiters liters: Int) -> String? {
        guard liters > 0 else { return nil }
        
        let filteredMessages = messages.filter { Int($0.minLiters) <= liters }
        
        guard !filteredMessages.isEmpty else { return nil }
        
        let randomIndex = Int(arc4random_uniform(UInt32(filteredMessages.count)))
        let message = filteredMessages[randomIndex]
        let result : Int = Int(Double(liters) / message.divideBy)
        
        guard result > 0 else { return nil }
        
        return message.text.replacingOccurrences(of: "*", with: "\(result)")
    }
}
