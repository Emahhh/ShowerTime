import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var mySettings = SettingsManager.shared
    @ObservedObject var myStats = UserStats.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("⏳ Max Shower Time")) {
                    Stepper(value: $mySettings.maxShowerTime, in: 1...15, step: 1) {
                        Text("\(mySettings.maxShowerTime) minutes")
                    }
                }
                
                Section(header: Text("🚿 Type of showerhead")) {
                    Picker("Select Your Showerhead Type", selection: $mySettings.litersPerMinute) {
                        Text("Inefficient 😵").tag(20)
                        Text("Efficient 🌿").tag(8)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("Choose your type of showehead to have a better extimation of how many liters your shower consumes per minute.\nSelect between an inefficient showerhead that uses 20 L/min or an efficient showerhead that uses 8 L/min. If you are not sure, select the inefficient showerhead.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }

 
                
                Section(header: Text("❌ Reset")) {
                    Button(action: {
                        myStats.resetStats()
                    }) {
                        Text("Reset Statistics 📈")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        mySettings.resetSettings()
                    }) {
                        Text("Reset Settings ⚙️")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("⚙️ Settings")
        }
        .background(Color.appBackground.edgesIgnoringSafeArea(.all))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
