import SwiftUI
import Combine

struct HomeView: View {

    @StateObject var showerData = ShowerData();
    @State private var isRunning: Bool = false;
    @State private var mySettings: ShowerSettings = ShowerSettings();

    
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
                
                
                // Show "End Shower" button only if the timer is active
                if isRunning {
                    
                    
                    Button("End Shower") {
                        endShower()
                    }
                    .padding()
                    
                    HStack {
                        Text("\(timeSoFar())")
                        Text("- \(timeLeft())")
                    }
                    .padding()

                } else {
                    // Show "Start Shower" button only if the timer hasn't started
                    Button("Start Shower") {
                        startTimer()
                    }
                    .padding()
                }

                
                Spacer()
            }
        }
        .onReceive(timerPublisher) { _ in
            // when I recieve an event from the timer
            // I update the timer values (every 1 second)
            updateTimerAndData()
        }
    } // end of the view's body
    
    
    
    
    func timeLeft() -> String {
        guard let startTime = showerData.startTime else { return "N/A" }
        let elapsedTime = Date().timeIntervalSince(startTime)
        let remainingTime = max(0, mySettings.maxShowerTime - elapsedTime)
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
        isRunning = true;
        showerData.startTime = Date()

    }

    func updateTimerAndData() {
        guard isRunning else {return};
        
        guard let startTime = showerData.startTime else {
            print("Error: startTime is nil")
            return;
        };
        
        let elapsedTime = Date().timeIntervalSince(startTime)
        
        // Check if the maximum shower time is reached
        if elapsedTime >= mySettings.maxShowerTime {
            // TODO: keep going but with alert
            // TODO: decide when to notify
        }
        
        let litersDouble : Double = Double(mySettings.litersPerMinute) * (elapsedTime/60);
        showerData.litersConsumed = Int(litersDouble);
    }

    func endShower() {
        updateTimerAndData(); // update data one last time
        isRunning = false;
        showerData.endTime = Date();
        // TODO: save the shower data
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

