import SwiftUI
import Combine

struct HomeView: View {

    @StateObject var showerData = ShowerData()
    @State private var timer: Timer?
    private var timerPublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.appBackground
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Welcome to ShowerTime!")
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: 250, height: 250)
                        .shadow(radius: 10)
                        .foregroundColor(Color.white.opacity(0.5))
                    
                    Text("\(showerData.litersConsumed) L")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .shadow(radius: 10)
                }
                .background(
                    Color.white
                        .opacity(0.1)
                        .blur(radius: 10)
                )
                
                HStack {
                    Text("\(timeSoFar())")
                    Text(" - \(timeLeft()) left")
                }
                .padding()
                
                Spacer()
                
                // Show "Start Shower" button only if the timer hasn't started
                if showerData.startTime == nil {
                    Button("Start Shower") {
                        startTimer()
                    }
                    .padding()
                }
                
                // Show "End Shower" button only if the timer is active
                if showerData.startTime != nil && showerData.endTime == nil {
                    Button("End Shower") {
                        endShower()
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
        .onReceive(timerPublisher) { _ in
            updateTimer()
        }
    }
    
    func timeLeft() -> String {
        guard let startTime = showerData.startTime else { return "N/A" }
        let elapsedTime = Date().timeIntervalSince(startTime)
        let remainingTime = max(0, Constants.maxShowerTime - elapsedTime)
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d left", minutes, seconds)
    }
    
    func timeSoFar() -> String {
        guard let startTime = showerData.startTime else { return "N/A" }
        let elapsedTime = Date().timeIntervalSince(startTime)
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func startTimer() {
        showerData.startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateTimer()
        }
    }

    func updateTimer() {
        guard let startTime = showerData.startTime else { return }
        let elapsedTime = Date().timeIntervalSince(startTime)

        // Check if the maximum shower time is reached
        if elapsedTime >= Constants.maxShowerTime {
            endShower()
        }

        // Update liters consumed based on flow rate and elapsed time
        // This part needs to be implemented based on your specific logic
        // Example: showerData.litersConsumed = flowRate * elapsedTime / 60
    }

    func endShower() {
        timer?.invalidate()
        showerData.endTime = Date()
        // Add logic to calculate and update liters consumed
        // You can use a flow rate (liters per minute) and elapsed time
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

