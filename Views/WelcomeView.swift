//
//  File.swift
//
//
//  Created by Emanuele Buonaccorsi on 26/02/24.
//

import SwiftUI

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

struct WelcomeView: View {
    @State var hideButton = false

    @State var showBullet1 = false
    @State var showBullet2 = false
    @State var showBullet3 = false
    @State var showBullet4 = false
    @State var showBullet5 = false

    var body: some View {
        VStack() {
            Text("Welcome to ShowerTime! 🚿")
                .font(.title)

           

            MascotView(
                withPicture: "greeting",
                withText: "Hi! My name is Droppy and I'll guide you on your journey to save water!"
            ).padding(.bottom, 21.0)
            
            
            Text("ShowerTime raises awareness of your water consumption and adds a fun twist to your showers!")
                .padding(.bottom)
            VStack(alignment: .leading, spacing: 7){
                BulletPoint(text: "Save water and help the enviroment by deciding to take shorter showers 🌎", isVisible: showBullet1)
                BulletPoint(text: "Set your shower duration target in the settings ⚙️", isVisible: showBullet2)
                BulletPoint(text: "Start the timer before turning your shower on ⏳", isVisible: showBullet3)
                BulletPoint(text: "You'll hear a sound when the timer is running out 🔈", isVisible: showBullet4)
                BulletPoint(text: "End your shower in time every day and keep your streak running 🔥", isVisible: showBullet5)
            }
            .padding(.top, 3.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0)) {
                    showBullet1 = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        showBullet2 = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        showBullet3 = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        showBullet4 = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        showBullet5 = true
                    }
                }

            } // end onApper
            .padding()
            
            if !hideButton {
                // button to navigate back to ContentView
                NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                    Text("Start saving water!")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .padding(.top, 8.0)
                }
                .navigationBarBackButtonHidden(true)
                .onTapGesture {
                    UserDefaults.standard.set(false, forKey: "isFirstLaunch")
                }
            }
           
        }
        .padding(.all, 20)
        
        
        

    }
}

struct BulletPoint: View {
    let text: String
    let isVisible: Bool

    var body: some View {
        HStack {
            Text("• " + text)
                .opacity(isVisible ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.5))
        }
    }
}
