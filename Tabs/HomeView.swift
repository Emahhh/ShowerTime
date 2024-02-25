import Combine
import SwiftUI

// previews in different states of the timer
struct HomeView_Previews: PreviewProvider {
    // Preview with normal HomeView
    static var normalPreview: some View {
        HomeView()
    }

    // Preview where the timer just started
    static var startedStatePreview: some View {
        let homeView = HomeView()
        homeView.previewStartedState()
        return homeView
    }

    // Preview where the timer is very late
    static var startedAndLateStatePreview: some View {
        let homeView = HomeView()
        homeView.previewStartedAndLateState()
        return homeView
    }

    static var previews: some View {
        Group {
            // Normal HomeView preview
            normalPreview
                .previewDisplayName("Normal HomeView")

            // Preview with started state
            startedStatePreview
                .previewDisplayName("HomeView - Started State")

            // Preview with started and late state
            startedAndLateStatePreview
                .previewDisplayName("HomeView - Started and Late State")
        }
    }
}

struct HomeView: View {
    @State private var waterMessagesManager = WaterMessagesManager()

    @State private var showEndAlert: Bool = false
    @State private var alertMessage: String = ""

    @State private var isTextVisible = false

    @State private var confettiCounter: Int = 0
    @State private var bouncerCount: Int = 0
    @State var counter: Int = 0

    // singleton instances
    @ObservedObject var mySettings = SettingsManager.shared
    @ObservedObject var myUserStats = UserStats.shared
    @ObservedObject var currShower = Shower.shared

    private var timerPublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.appBackground
                .edgesIgnoringSafeArea(.all)

            ZStack {
                // MARK: - Title

                VStack {
                    HStack {
                        Text("ShowerTime 🚿")
                            .font(.title)
                            .fontWeight(.heavy)
                    }
                    Spacer()
                }
                .padding(.top, 25.0)

                // MARK: - Central square (WaterView)

                WaterView(
                    litersConsumed: currShower.litersConsumed,
                    maxLiters: mySettings.maxShowerTime / 60 * mySettings.litersPerMinute,
                    isRunning: currShower.isRunning,
                    onStart: {
                        withAnimation {
                            startShower()
                        }
                    },
                    bouncerCount: bouncerCount
                )
                .padding(.bottom, 150.0)

                // MARK: - VStack containing Buttons

                VStack {
                    Spacer()

                    // If the user has already pressed "start"...
                    if currShower.isRunning {
                        VStack {
                            // Pause and End Buttons
                            HStack {
                                // Pause / Play button
                                Button(action: currShower.togglePause) {
                                    Image(systemName: currShower.isPaused ? "play.fill" : "pause.fill")
                                        .padding(15)
                                        .background(currShower.isPaused ? Color.blue : Color.gray)
                                        .foregroundColor(.white)
                                        .clipShape(Circle())
                                        .cornerRadius(40)
                                        .shadow(color: .gray, radius: 3, x: 0, y: 2)
                                }

                                Text("\(currShower.timeLeftString)")
                                    .bold()
                                    .frame(width: 70) // Fixed-width container so that it doesnt move everything

                                // End button
                                Button(action: {
                                    withAnimation {
                                        endShower()
                                    }
                                }) {
                                    // TODO: add bounce animation??
                                    HStack {
                                        Text("END")
                                            .bold()
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(
                                        LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .cornerRadius(30)
                                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
                                }
                            }
                        }
                        .padding(.bottom, 150)
                    }
                }
                .padding(.bottom, 70)

                // MARK: - mascotte messages

                VStack {
                    Spacer()
                    // if the user ran out of time, show an ultimatum countdown
                    if currShower.isPastMaxTime {
                        VStack {
                            Text("Time to end your shower!")
                                .font(.title)
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.center)
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
                    }

                    // Water messages ("that's enough water to...")
                    if let message = waterMessagesManager?.getWaterMessage(forLiters: currShower.litersConsumed) {
                        Text(message)
                    }
                } // end of mascotte's vstack
                .padding(.all)
                .padding(.bottom, 25)

                // MARK: - Streak on the top-right corner

                if !currShower.isRunning {
                    VStack {
                        Spacer()
                        StreakView(streakCount: myUserStats.streak)
                            .padding(.bottom, 50.0)
                    }
                }
            } // end of ZStack containing elements
        } // end of the first ZStack (containing background)
        .onReceive(timerPublisher) { _ in
            // when I recieve an event from the timer (every 1 second, possibly)

            // I update the shower values
            currShower.update()

            // Increment bouncerCount once every 3 times
            counter += 1
            if counter % 2 == 0 {
                guard !currShower.isRunning || currShower.isPastMaxTime else {
                    return
                }
                bouncerCount += 1
            }
        }
        .alert(isPresented: $showEndAlert) {
            Alert(title: Text("Shower Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .confettiCannon(counter: $confettiCounter, confettis: [.text("💦"), .text("💙"), .text("💧"), .text("🌿")])
    } // end of the view's body

    func previewStartedState() {
        endShower()
        startShower()
    }

    func previewStartedAndLateState() {
        endShower()
        startShower()
        currShower.simulateLate()
    }

    func startShower() {
        currShower.start()
    }

    func endShower() {
        currShower.update()
        currShower.end()

        isTextVisible = false

        // TODO: save the shower data
        myUserStats.saveNewShower(
            isWon: currShower.won,
            litersConsumed: currShower.litersConsumed,
            litersSaved: 1 // TODO: calculate extimation liters saved
        )

        // TODO: celebrate won or loss in a nice way
        // Show alert to celebrate win or loss
        alertMessage = currShower.won ? "Congratulations! You saved water!" : "Oops! You exceeded the time. :(\n"
        showEndAlert = true
        // TODO: confetti animation
        if currShower.won {
            confettiCounter += 1
        }

        currShower.reset()
        currShower.update()
    }
}

struct StreakView: View {
    var streakCount: Int

    var body: some View {
        if streakCount > 0 {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color.blue) // Customize the color of the pill shape
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2) // Add shadow effect for depth

                Text("Streak: \(streakCount) 🔥")
                    .foregroundColor(.white) // Text color
                    .font(.headline) // Text font style
                    .padding(5)
            }
            .frame(width: 150, height: 40) // Adjust the height of the pill shape
            .padding(20) // Add padding for spacing
        }
    }
}

struct WaterView: View {
    var litersConsumed: Int
    var maxLiters: Int
    var isRunning: Bool
    var onStart: () -> Void
    var bouncerCount: Int = 0

    var body: some View {
        GeometryReader { _ in
            ZStack(alignment: .bottom) {
                // Mask for water level to be visible only inside the white rectangle
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: 250, height: 250)
                    .foregroundColor(.blue)
                    .mask(alignment: Alignment.bottom) {
                        RoundedRectangle(cornerRadius: 0)
                            .frame(width: 250, height: min(CGFloat(litersConsumed) / CGFloat(maxLiters) * 250, 250))
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
                            .symbolEffect(.bounce, value: bouncerCount)
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
