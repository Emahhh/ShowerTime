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
                Button("Reset statistics") {
                    myStats.resetStats();
                }
                Button("Reset settings") {
                    mySettings.resetSettings();
                }
                
                Text(
                    """
                    
                    Here is a preview of the settings:
                    Max shower time: \(mySettings.maxShowerTime)
                    Liters per minute: \(mySettings.litersPerMinute)
                    Grace period: \(mySettings.gracePeriod)
                    """
                )

            }
            
            
        }
    }
}



#Preview {
    SettingsView()
}
