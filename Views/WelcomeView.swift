//
//  File.swift
//  
//
//  Created by Emanuele Buonaccorsi on 26/02/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to My App!")
                .font(.largeTitle)
                .padding()

            // Add a button to navigate back to ContentView
            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                Text("Continue")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
