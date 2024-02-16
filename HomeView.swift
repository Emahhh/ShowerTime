import SwiftUI
import Combine

struct HomeView: View {

    @State var showerData = ShowerData();
    @State private var mySettings: ShowerSettings = ShowerSettings();
    
    @State private var isStarted: Bool = false;
    
    @State private var timeSoFar : String = "00:00";
    @State private var timeLeft : String = "00:00";
    
    @State private var isPastMaxTime : Bool = false;

    
    
    
    // pause variables ---------
    
    // timestamp of the last time the "pause" button was pressed
    // if the timer is not in pause right now, it must be nil
    @State private var currentPauseStartTimestamp : Date? = nil;
    
    // time passed during various pauses, to be subtracted when calculating the time so far, and updated when ending a pause or the shower
    @State private var totalPausedTime : Int = 0;
    


    
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
                if isStarted {
                    
                    
                    Button("End Shower") {
                        endShower()
                    }
                    .padding()
                    
                    
                    Button(action: handlePause) {
                                    Text(isPaused() ? "Resume" : "Pause")
                                        .font(.title)
                                        .padding()
                                        .background(isPaused() ? Color.green : Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                    }
                    
                    
                    HStack {
                        Text("\(timeSoFar)")
                        Text("- \(timeLeft)")
                    }
                    .padding()
                    
                    
                    if isPastMaxTime {
                        Text("OOOOO stop!!!")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .rotationEffect(Angle(degrees:-5))
                    }
                    
                    

                } else {
                    // Show "Start Shower" button only if the timer hasn't started
                    Button("Start Shower") {
                        startTimer()
                    }
                    .padding()
                }

                
                Spacer()
            }
            
            
            
        } // end of VStack
        .onReceive(timerPublisher) { _ in
            // when I recieve an event from the timer
            // I update the timer values (every 1 second)
            updateTimerAndData()
        }
        
        
        
    } // end of the view's body
    
    
    
    func isPaused() -> Bool {
        return currentPauseStartTimestamp != nil;
    }

    func startTimer() {
        showerData.startTime = Date();
        updateTimerAndData();
        isStarted = true;
        updateTimerAndData();

    }
    
    func endShower() {
        updateTimerAndData(); // update data one last time
        isStarted = false;
        showerData.endTime = Date();
        // TODO: save the shower data
        
        // reset showerData and pause tracker
        showerData = ShowerData();
        currentPauseStartTimestamp = nil;
        totalPausedTime = 0;
        isPastMaxTime = false;
    }
    
    func handlePause() {
        if let t = currentPauseStartTimestamp {
            totalPausedTime += Int(Date().timeIntervalSince(t));
            currentPauseStartTimestamp = nil;
        } else {
            currentPauseStartTimestamp = Date();
        }
    }
    
    
    
    func updateTimerAndData() {
        guard isStarted else { return }
        
        guard let startTime = showerData.startTime else {
            print("Error: startTime is nil, but isStarted is true!")
            return;
        }
        
        // update paused time
        let cpst = self.currentPauseStartTimestamp ?? Date();
        let currentPausedTime = Int(Date().timeIntervalSince(cpst));
        
        showerData.showerDuration = Int(Date().timeIntervalSince(startTime)) - totalPausedTime - currentPausedTime;
        
        
        showerData.litersConsumed = Int(Double(mySettings.litersPerMinute) * Double(showerData.showerDuration) / 60)
        
        // time so far to be shown in the view
        let minutesSoFar = showerData.showerDuration / 60
        let secondsSoFar = showerData.showerDuration % 60
        timeSoFar = String(format: "%02d:%02d", minutesSoFar, secondsSoFar)
        
        // time left to be shown
        let remainingTime : Int = mySettings.maxShowerTime - showerData.showerDuration;
        let minutesLeft = Int(remainingTime) / 60
        let secondsLeft = Int(remainingTime) % 60
        timeLeft = String(format: "%02d:%02d left", minutesLeft, secondsLeft)
    
    
        // Check if the maximum shower time is reached
        if showerData.showerDuration >= mySettings.maxShowerTime {
            isPastMaxTime = true;
            // TODO: decide when to notify with sound
        }
    }
    
    
    

}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

