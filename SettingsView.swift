//
//  SettingsView.swift
//  primo-playground
//
//  Created by Emanuele Buonaccorsi on 09/02/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color.appBackground
                .edgesIgnoringSafeArea(.all)
            
            Text("Hello, Settings!")
            
        }
    }
}

#Preview {
    SettingsView()
}
