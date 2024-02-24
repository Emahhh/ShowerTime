import SwiftUI
import Combine


struct HomeView: View {

    
    @State private var waterMessagesManager = WaterMessagesManager();

    @State private var showEndAlert : Bool = false;
    @State private var alertMessage : String = "";
    
    // singleton instances
    @ObservedObject var mySettings = SettingsManager.shared;
    @ObservedObject var myUserStats = UserStats.shared;
    @ObservedObject var currShower = Shower.shared;
    

    
    private var timerPublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.appBackground
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Streak: \(myUserStats.streak)")
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: 250, height: 250)
                        .shadow(radius: 10)
                        .foregroundColor(Color.white.opacity(0.5))
                    
                    VStack{
                        if !currShower.isRunning { // Show "Start Shower" button only if the timer hasn't started
                            
                            Button(action: {
                                withAnimation {
                                    currShower.start()
                                }
                            }) {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .buttonStyle(DefaultButtonStyle())
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(80)
                            .shadow(radius: 7)


                            
                            Text("Start Shower")
                                .bold()
                                
                        } else { // when the user has already pressed "start"...
                            
                            Text("\(currShower.litersConsumed) L")
                                .font(.largeTitle)
                                .fontWeight(.black)
                                .shadow(radius: 10)
                        }
                    }
                    
                    
                }
                .background(
                    Color.white
                        .opacity(0.1)
                        .blur(radius: 10)
                )
                
                
                // if the user has already pressed "start"...
                if currShower.isRunning {
                    
                    HStack(spacing: 60) {
                        
                        // pause / play button
                        Button(action: currShower.togglePause) {
                            Image(systemName: currShower.isPaused ? "play.fill" : "pause.fill")
                                .padding(15)
                                .background(currShower.isPaused ? Color.green : Color.red)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .cornerRadius(80)
                        }
                    
                        
                        Button(action: {
                            withAnimation {
                                endShower()
                            }
                        }) {
                            Text("END")
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        
                    }
                    
                    

                    
                    
                    if currShower.isPastMaxTime {
                        // TODO: animazioni e suoni
                        Text("Time to end your shower!")
                            .font(.largeTitle)
                            .fontWeight(.black)
                        
                        // time left before you lose your streak
                        let timeLeft : Int = mySettings.maxShowerTime + mySettings.gracePeriod - currShower.showerDuration;
                        
                        if timeLeft > 0 {
                            Text("End your shower in \(timeLeft) seconds to not lose your streak!")
                        }
                        
            
                    } else {
                        HStack {
                            Text("\(currShower.timeLeftString)")
                        }
                        .padding()
                    }
                    
                    
                    // Water messages ("that's enough water to...")
                    if let message = waterMessagesManager?.getWaterMessage(forLiters: currShower.litersConsumed) {
                        Text(message)
                    }
                    

                }

                
                Spacer()
            }
            
            
            
        } // end of VStack
        .onReceive(timerPublisher) { _ in
            // when I recieve an event from the timer
            // I update the timer values (every 1 second)
            currShower.update()
        }
        .alert(isPresented: $showEndAlert) {
            Alert(title: Text("Shower Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        
        
        
    } // end of the view's body
    
    
    
    
    
    
    
    
    func endShower() {
        currShower.update()
        currShower.end();
        
        // TODO: save the shower data
        myUserStats.saveNewShower(
            isWon: currShower.won,
            litersConsumed: currShower.litersConsumed,
            litersSaved: 1 // TODO: calculate extimation liters saved
        );

        // TODO: celebrate won or loss in a nice way
        // Show alert to celebrate win or loss
        alertMessage = currShower.won ? "Congratulations! You saved water!" : "Oops! You exceeded the time. :(\n";
        showEndAlert = true;
        //TODO: confetti animation
        
        currShower.reset()
        currShower.update()
    }
        
    
    

}










struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
