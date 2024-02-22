//
//  SettingsView.swift
//  primo-playground
//
//  Created by Emanuele Buonaccorsi on 09/02/24.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var mySettings = ShowerSettingsManager.shared;
    @ObservedObject var myStats = UserStats.shared;
    
    var body: some View {
        ZStack {
            Color.appBackground
                .edgesIgnoringSafeArea(.all)
            
            
            VStack{
                Text("Hello, Settings!")

                
                Text(
                    """
                    
                    Here is a preview of the settings:
                    Max shower time: \(mySettings.maxShowerTime)
                    Liters per minute: \(mySettings.litersPerMinute)
                    Grace period: \(mySettings.gracePeriod)
                    """
                )
                
                Divider()

                
                Button("Reset statistics") {
                    myStats.resetStats();
                }
                Button("Reset settings") {
                    mySettings.resetSettings();
                }
                
                
                Divider()
                
                
                // TODO: disattiva quando una doccia è in corso
                Stepper(value: mySettings.$maxShowerTime, in: 4...15, step: 1) {
                    Text("Max Shower Time: \(mySettings.maxShowerTime) minutes")
                }
                               
                Picker("Select your kind of showerhead", selection: mySettings.$litersPerMinute) {
                    Text("8 liters per minute (efficient showerhead)").tag(8)
                    Text("20 liters per minute (inefficient)").tag(20)
                }
                               

            }
            
            
        }
    }
}



#Preview {
    SettingsView()
}
