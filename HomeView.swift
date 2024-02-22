import SwiftUI
import Combine

struct HomeView: View {

    @State var showerData = ShowerData();
    @State private var mySettings: ShowerSettings = ShowerSettings();
    
    @State private var isStarted: Bool = false;
    
    @State private var timeSoFar : String = "00:00";
    @State private var timeLeft : String = "00:00";
    
    @State private var isPastMaxTime : Bool = false;
    
    @State private var waterMessagesManager = WaterMessagesManager();

    
    @State private var showEndAlert : Bool = false;
    @State private var alertMessage : String = "";
    
    
    
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
                        Text("- \(timeLeft)") // TODO: non mostrare valori negativi quando finito tempo
                    }
                    .padding()
                    
                    
                    if isPastMaxTime {
                        Text("OOOOO stop!!!")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .rotationEffect(Angle(degrees:-5))
                    }
                    
                    if let message = waterMessagesManager?.getWaterMessage(forLiters: showerData.litersConsumed) {
                        Text(message)
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
        .alert(isPresented: $showEndAlert) {
            Alert(title: Text("Shower Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        
        
        
    } // end of the view's body
    
    
    
    
    
    
    
    
    func isPaused() -> Bool {
        return currentPauseStartTimestamp != nil;
    }

    func startTimer() {
        debugPrint("Starting timer!");
        
        showerData.startTime = Date();
        updateTimerAndData();
        isStarted = true;
        updateTimerAndData();

    }
    
    func endShower() {
        debugPrint("Ending shower!");
        updateTimerAndData(); // update data one last time
        isStarted = false;
        showerData.endTime = Date();
        showerData.won = showerData.showerDuration <= (mySettings.maxShowerTime + mySettings.gracePeriod);
        
        // TODO: save the shower data
        UserStatistics.saveNewShower(
            isWon: showerData.won,
            litersConsumed: showerData.litersConsumed,
            litersSaved: 1 // TODO: calculate extimation liters saved
        );

        
        
        
        // TODO: celebrate won or loss in a nice way ----
        
        // Show alert to celebrate win or loss
        alertMessage = showerData.won ? "Congratulations! You saved water!" : "Oops! You exceeded the allowed shower time. :(";
        alertMessage += " You won \(UserStatistics.totalTimesWon) times so far!";
        showEndAlert = true;
        //TODO: confetti animation
        
        
        // reset showerData and pause tracker ------
        showerData = ShowerData(); // resets
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
    
    
    
    
    
    
    /// Updates the variables so that they show the time passed so far.
    ///
    /// this function is ran (possibly) once every second
    func updateTimerAndData() {
        guard isStarted else { return }
        
        guard let startTime = showerData.startTime else {
            print("Error: startTime is nil, but isStarted is true!")
            return;
        }
        
        // in this case, we are in a pause. we do not update the view.
        guard (self.currentPauseStartTimestamp == nil) else { return }

        
        
        showerData.showerDuration = Int(Date().timeIntervalSince(startTime)) - totalPausedTime;
        
        
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

