import SwiftUI

struct SettingsView: View {

  @ObservedObject var mySettings = SettingsManager.shared
  @ObservedObject var myStats = UserStats.shared

  var body: some View {
    NavigationView {
      List {

        Section(header: Text("water conmsumption")) {
          NavigationLink(destination: MaxShowerTimeView()) {
            HStack {
              Text("⏳ Max Shower Time")
                //.font(.headline)
                .fontWeight(.bold)
                // .foregroundColor(.blue)
                .padding()
              Spacer()
              Text("\(mySettings.maxShowerTime) minutes")
              //.padding()
            }
          }

          NavigationLink(destination: ShowerheadTypeView()) {
            HStack {
              Text("🚿 Your Showerhead")
                //.font(.headline)
                .fontWeight(.bold)
                // .foregroundColor(.blue)
                .padding()
              Spacer()
              Text("\(mySettings.litersPerMinute) L/min")
              //.padding()
            }
          }

        }

        Section(header: Text("Info")) {
          NavigationLink(destination: EmptyView()) {
            HStack {
              Text("About")
            }
          }

          NavigationLink(destination: EmptyView()) {
            HStack {
              Text("How to use this app")
            }
          }

        }

        Section(header: Text("Reset")) {
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
      .listStyle(InsetGroupedListStyle())  // Use a list style here
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

struct MaxShowerTimeView: View {
  @ObservedObject var mySettings = SettingsManager.shared

  var body: some View {
    Form {
      Stepper(value: $mySettings.maxShowerTime, in: 1...15, step: 1) {
        Text("\(mySettings.maxShowerTime) minutes")
      }

      Text(
        """
        Choose your target shower duration. You'll have to end your shower within this time to win and earn your streak. You'll receive a notification when the timer is over, and you'll have some time to end your shower.
        """
      )
      .font(.caption)
      .foregroundColor(.gray)
      .padding(1)
    }
    .navigationBarTitle("⏳ Max Shower Time")
  }
}

struct ShowerheadTypeView: View {
  @ObservedObject var mySettings = SettingsManager.shared

  var body: some View {
    Form {
      Picker("Select Your Showerhead Type", selection: $mySettings.litersPerMinute) {
        Text("Inefficient 😵").tag(19)
        Text("Efficient 🌿").tag(9)
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding(4)

      Text(
        """
        Choose your type of showerhead to have a better estimation of how many liters your shower consumes per minute.
        - An inefficient showerhead uses roughly 19 L/min
        - An efficient showerhead uses 9 L/min.
        If you are not sure, select the inefficient showerhead.
        """
      )
      .font(.caption)
      .foregroundColor(.gray)
      .padding(1)
    }
    .navigationBarTitle("🚿 Type of Showerhead")
  }
}
