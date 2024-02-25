import SwiftUI
import Combine

struct WaterView: View {
    var litersConsumed: Int
    var maxLiters: Int
    var isRunning: Bool
    var onStart: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {

                // Mask for water level to be visible only inside the white rectangle
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: 250, height: 250)
                    .foregroundColor(.blue)
                    .mask(alignment: Alignment.bottom){
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: 250, height: CGFloat(litersConsumed) / CGFloat(maxLiters) * 250)
                            .foregroundColor(.blue)
                            .opacity(0.7)
                            .animation(.easeInOut)
                    }
                

                ZStack {
                    // White rectangle
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: 250, height: 250)
                        .shadow(radius: 10)
                        .foregroundColor(Color.white.opacity(0.5))
                        .background(
                            Color.white
                                .opacity(0.1)
                                .blur(radius: 100) // TODO: not working
                        )

                    if !isRunning {
                        // If no timer is running, display the play button to start it
                        VStack {
                            Button(action: onStart) {
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
                        }
                    }

                    // If the timer is running, show a big number with the amount of liters consumed so far
                    if isRunning {
                        Text("\(litersConsumed) L")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .shadow(radius: 10)
                    }
                }
            }
        }
        .frame(width: 250, height: 250)
    }
}







struct HomeView: View {

    
    @State private var waterMessagesManager = WaterMessagesManager();

    @State private var showEndAlert : Bool = false;
    @State private var alertMessage : String = "";
    
    @State private var isTextVisible = false
    
    @State private var confettiCounter : Int = 0;
    
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
                
                
                // MARK: - Central square
                WaterView(
                    litersConsumed: currShower.litersConsumed,
                    maxLiters: mySettings.maxShowerTime * mySettings.litersPerMinute,
                    isRunning: currShower.isRunning,
                    onStart: {
                        withAnimation {
                            currShower.start()
                        }
                    }
                )

                // end of the central square

                
                
                // MARK: - Buttons
                // if the user has already pressed "start"...
                if currShower.isRunning {
                    
                    HStack(spacing: 60) {
                        
                        // pause / play button
                        Button(action: currShower.togglePause) {
                            Image(systemName: currShower.isPaused ? "play.fill" : "pause.fill")
                                .padding(15)
                                .background(currShower.isPaused ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .cornerRadius(40)
                                .shadow(color: .gray, radius: 3, x: 0, y: 2)
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
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .cornerRadius(30)
                                .shadow(color: .gray, radius: 4, x: 0, y: 2)
                        }
                        
                    }
                    
                    

                    
                    // if the user ran out of time, show an ultimatum countdown
                    if currShower.isPastMaxTime {
                        VStack {
                            Text("Time to end your shower!")
                                .font(.largeTitle)
                                .fontWeight(.black)
                                .opacity(isTextVisible ? 1.0 : 0.0) // Initially set to invisible
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 0.7)) {
                                        isTextVisible = true // Trigger the fade-in animation
                                    }
                                }

                            let timeLeft: Int = mySettings.maxShowerTime + mySettings.gracePeriod - currShower.showerDuration

                            if timeLeft > 0 {
                                Text("End in \(timeLeft) seconds to keep your streak going!")
                                    .opacity(isTextVisible ? 1.0 : 0.0) // Initially set to invisible
                                    .onAppear {
                                        withAnimation(.easeInOut(duration: 0.7)) {
                                            isTextVisible = true // Trigger the fade-in animation
                                        }
                                    }
                            }
                        }
                    } else {
                        // if the user still has time left, just show the time left
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
        .confettiCannon(counter: $confettiCounter, confettis: [.text("💦"), .text("💙"), .text("💧"), .text("🌿")])
               
        
        
        
    } // end of the view's body
    
    
    
    
    
    
    
    
    func endShower() {
        currShower.update()
        currShower.end();
        
        isTextVisible = false
        
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
        if currShower.won {
            confettiCounter+=1;
        }
        
        currShower.reset()
        currShower.update()
    }
        
    
    

}










struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
