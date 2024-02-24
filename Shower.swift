import SwiftUI
import AVFoundation

class Shower: ObservableObject {
    static var shared = Shower()
    
    private init() {
        self.reset()
    }
    
    @Published var startTime: Date?
    @Published var endTime: Date?
    @Published var timeLeft: String = ""
    @Published var showerDuration: Int = 0
    @Published var litersConsumed: Int = 0
    @Published var won: Bool = false
    @Published var isPastMaxTime: Bool = false
    
    /// true from start to end.
    ///
    /// can be true even if in pause.
    @Published var isRunning: Bool = false;
    @Published var isPaused: Bool = false;
    
    
    private var audioManager = AudioManager();
    
    // pause variables ---------
    
    // timestamp of the last time the "pause" button was pressed
    // if the timer is not in pause right now, it must be nil
    private var currentPauseStartTimestamp : Date? = nil;
    
    // time passed during various pauses, to be subtracted when calculating the time so far, and updated when ending a pause or the shower
    private var totalPausedTime : Int = 0;
    

    
        
    func start() {
        startTime = Date()
        isRunning = true;
    }
    
    func end(){
        debugPrint("Ending shower!");
        isRunning = false;
        audioManager.stopSound()
        
        self.update(); // update data one last time
        
        self.endTime = Date();
        self.won = self.showerDuration <= (ShowerSettingsManager.shared.maxShowerTime + ShowerSettingsManager.shared.gracePeriod);
    }
    
    
    func reset() {
        print("resetting")
        audioManager.stopSound()
        startTime = nil
        endTime = nil
        timeLeft = secondsToTimestampString(secs: ShowerSettingsManager.shared.maxShowerTime);
        showerDuration = 0
        litersConsumed = 0
        won = false
        isPastMaxTime = false
        isRunning = false
        isPaused = false
        currentPauseStartTimestamp = nil
        totalPausedTime = 0
        // print(self.description)
    }
    
    func togglePause(){
        isPaused.toggle()
        audioManager.stopSound()
        
        if let t = currentPauseStartTimestamp {
            totalPausedTime += Int(Date().timeIntervalSince(t));
            currentPauseStartTimestamp = nil;
        } else {
            currentPauseStartTimestamp = Date();
        }
    }
    
    
    /// Updates the variables to display the remaining time and other shower data.
    ///
    /// This function is called periodically to update the displayed information.
    func update() {
        guard self.isRunning else { return }
        
        guard let startTime = self.startTime else {
            print("Error: startTime is nil, but isStarted is true!")
            return
        }
        
        // Check if the shower is currently paused
        guard currentPauseStartTimestamp == nil else { return }
        
        // Calculate shower duration
        self.showerDuration = Int(Date().timeIntervalSince(startTime)) - totalPausedTime
        
        // Calculate liters consumed
        self.litersConsumed = Int(Double(ShowerSettingsManager.shared.litersPerMinute) * Double(self.showerDuration) / 60)
    
        
        // Calculate time left
        let remainingTime: Int = ShowerSettingsManager.shared.maxShowerTime - self.showerDuration
        self.timeLeft = secondsToTimestampString(secs: remainingTime);
        
        // Check if the maximum shower time is reached
        if self.showerDuration >= ShowerSettingsManager.shared.maxShowerTime {
            self.isPastMaxTime = true
            // TODO: decide when to notify with sound: in advance or exactly at max time?
            audioManager.playSound()
        }
    }
    
    /// Converts seconds to a timestamp string of the form "MM:SS"
    func secondsToTimestampString(secs: Int) -> String{
        let minutes = Int(secs) / 60
        let seconds = Int(secs) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    


        
        var description: String {
            return """
            ShowerData:
            - isRunning: \(isRunning)
            - isPaused: \(isPaused)
            - showerDuration: \(showerDuration)
            - litersConsumed: \(litersConsumed)
            - won: \(won)
            - isPastMaxTime: \(isPastMaxTime)
            """
        }
        
     
    
}




class AudioManager {
    
    private var player: AVAudioPlayer?
    private var lastPlayTime: Date
    
    init() {
        lastPlayTime = Date.distantPast
    }

    /// Plays the sound only if it hasn't been played recently (in the last `interval` seconds)
    func playSound(interval: TimeInterval = 30) {
        guard let url = Bundle.main.url(forResource: "tyla_water", withExtension: "mp3") else {
            print("Error: unable to find file")
            return
        }

        // Check if enough time has passed since the last play
        guard Date().timeIntervalSince(lastPlayTime) >= interval else {
            print("Audio played recently. Ignoring.")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else {
                print("Error: unable to create player")
                return
            }
            player.play()
            lastPlayTime = Date()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func stopSound(){
        player?.stop()
        lastPlayTime = Date.distantPast
    }
}

