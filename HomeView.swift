//
//  HomeView.swift
//  primo-playground
//
//  Created by Emanuele Buonaccorsi on 09/02/24.
//

import SwiftUI

struct HomeView: View {
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
                    
                    Text("15 L")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .shadow(radius: 10)
                }
                .background(
                            Color.white
                                .opacity(0.1)
                                .blur(radius: 10) // Apply the blur effect only to the backdrop of the RoundedRectangle
                            )
                
                Spacer()
                
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}
