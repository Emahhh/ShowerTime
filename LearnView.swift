//
//  LearnView.swift
//  primo-playground
//
//  Created by Emanuele Buonaccorsi on 09/02/24.
//

import SwiftUI

struct LearnView: View {
    var body: some View {
        ZStack {
            Color.appBackground
                .edgesIgnoringSafeArea(.all)
            
            Text("Hello, Learn!")
            
        }
    }
}

#Preview {
    LearnView()
}
