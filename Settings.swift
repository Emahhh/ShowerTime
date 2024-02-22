import SwiftUI

struct ShowerSettings {
    @AppStorage("MaxShowerTime") var maxShowerTime: Int = 15
    @AppStorage("LitersPerMinute") var litersPerMinute: Int = 10
    @AppStorage("GracePeriod") var gracePeriod: Int = 5
}
