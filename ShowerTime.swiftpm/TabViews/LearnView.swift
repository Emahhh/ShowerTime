import SwiftUI


struct LearnView: View {
    var body: some View {
        
        ZStack{
            TikTokContentView()
            // TODO: add "scroll!!!"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Page5View_Previews: PreviewProvider {
    static var previews: some View {
        Page5View()
    }
}




struct TikTokContentView: View {
    @State private var currentPage = 0
    
    // TODO: implement in a smarter way that follows best practices
    // TODO: uncomment if neeeded
    let pageContentViews: [AnyView] = [
        AnyView(Page0View()),
        AnyView(Page1View()),
        AnyView(Page2View()),
        AnyView(Page3View()),
        AnyView(Page4QuizView()),
        AnyView(Page4View()),
        AnyView(Page5View()),
        AnyView(Page6View()),
        AnyView(Page7View()),
        AnyView(Page8View()),
//        AnyView(Page9View()),
//        AnyView(Page10View()),
//        AnyView(Page11View()),
//        AnyView(Page12View()),
//        AnyView(Page13View()),
//        AnyView(Page14View()),
//        AnyView(Page15View()),
//        AnyView(Page16View()),
//        AnyView(Page17View()),
//        AnyView(Page18View()),
//        AnyView(Page19View()),
//        AnyView(Page20View()),
//        AnyView(Page21View()),
//        AnyView(Page22View()),
//        AnyView(Page23View()),
//        AnyView(Page24View())
    ]


    var body: some View {
            VerticalPager(pageCount: pageContentViews.count, currentIndex: $currentPage) {
                ForEach(0..<pageContentViews.count) { index in
                    VStack{
                        pageContentViews[index]
                    }
                }
            }
        }
}




struct QuizCardView: View {
    var question: String = ""
    var options: [String]
    var correctOptionIndex: Int
    @State private var selectedOptionIndex: Int?
    @State private var showFeedback = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            if !question.isEmpty{
                Text(question)
                    .font(.headline)
                    .padding(.bottom, 5)
            }


            ForEach(options.indices, id: \.self) { index in
                Button(action: {
                    selectedOptionIndex = index
                    showFeedback = true
                }) {
                    HStack {
                        Image(systemName: imageForOption(index: index))
                            .foregroundColor(colorForOption(index: index))
                        Text(options[index])
                            .foregroundColor(.primary)
                    }
                }
                .disabled(showFeedback && index != correctOptionIndex) // Disable buttons after feedback is shown
            }

            if showFeedback {
                Text(feedbackMessage)
                    .foregroundColor(feedbackColor)
                    .padding(.top, 10)
            }
        }
        .frame(width: 300, height: 200, alignment: .center)
        .padding()
        .background(.ultraThickMaterial)
        .cornerRadius(10)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .padding()
    }

    private func imageForOption(index: Int) -> String {
        if showFeedback {
            if index == correctOptionIndex {
                return "checkmark.circle.fill"
            } else if index == selectedOptionIndex {
                return "xmark.circle.fill"
            }
        }
        return "circle"
    }

    private func colorForOption(index: Int) -> Color {
        if showFeedback {
            return index == correctOptionIndex ? .green : (index == selectedOptionIndex ? .red : .primary)
        }
        return .primary
    }

    private var feedbackMessage: String {
        if let selectedOptionIndex = selectedOptionIndex {
            return selectedOptionIndex == correctOptionIndex ? "Correct!" : "Wrong!"
        } else {
            return ""
        }
    }

    private var feedbackColor: Color {
        return selectedOptionIndex == correctOptionIndex ? .green : .red
    }
}










struct VerticalPager<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content

    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }

    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            LazyVStack(spacing: 0) {
                self.content.frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primary.opacity(0.000000001))
            .offset(y: -CGFloat(self.currentIndex) * geometry.size.height)
            .offset(y: self.translation)
            .animation(.interactiveSpring(response: 0.3), value: currentIndex)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture(minimumDistance: 1).updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let offset = -Int(value.translation.height)
                    if abs(offset) > 20 {
                        let newIndex = currentIndex + min(max(offset, -1), 1)
                        if newIndex >= 0 && newIndex < pageCount {
                            self.currentIndex = newIndex
                        }
                    }
                }
            )
        }
    }
}



struct learnColors {
    static let color0 = Color(red: 220/255, green: 241/255, blue: 254/255); // light blue
    static let color1 = Color(red: 143/255, green: 230/255, blue: 220/255); // turquoise
    static let color2 = Color(red: 169/255, green: 247/255, blue: 214/255); // mint green
    static let color3 = Color(red: 204/255, green: 255/255, blue: 204/255); // pale green
    static let color4 = Color(red: 255/255, green: 255/255, blue: 153/255); // lemon yellow
    static let color5 = Color(red: 255/255, green: 204/255, blue: 102/255); // peach
    static let color6 = Color(red: 255/255, green: 153/255, blue: 102/255); // coral
    static let color7 = Color(red: 255/255, green: 102/255, blue: 102/255); // salmon
    static let color8 = Color(red: 255/255, green: 153/255, blue: 204/255); // pink
    static let color9 = Color(red: 204/255, green: 153/255, blue: 255/255); // lavender
    static let color10 = Color(red: 153/255, green: 153/255, blue: 255/255); // light purple
    static let color11 = Color(red: 102/255, green: 153/255, blue: 255/255); // sky blue
    static let color12 = Color(red: 102/255, green: 204/255, blue: 255/255); // aqua
    static let color13 = Color(red: 102/255, green: 255/255, blue: 255/255); // cyan
    static let color14 = Color(red: 102/255, green: 255/255, blue: 204/255); // sea green
    static let color15 = Color(red: 102/255, green: 255/255, blue: 153/255); // lime green
    static let color16 = Color(red: 153/255, green: 255/255, blue: 102/255); // light green
    static let color17 = Color(red: 204/255, green: 255/255, blue: 102/255); // yellow green
    static let color18 = Color(red: 255/255, green: 255/255, blue: 102/255); // sunflower yellow
    static let color19 = Color(red: 255/255, green: 204/255, blue: 102/255); // orange
}


struct TextCardView: View {
    var title: String = ""
    let txtBody: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.thickMaterial)
                .shadow(radius: 5)
                .frame(width: 350)
                .frame(maxHeight: 325)
                .overlay(
                    VStack(alignment: .leading) {
                        if !title.isEmpty {
                            Text(title)
                                .font(.title2)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.bottom, 5.0)
                                .frame(minWidth: 315)
                        }
                        
                        Text(txtBody)
                            .font(.body)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.8)
                            .frame(minWidth: 315)
                    }
                    .padding()
                    .multilineTextAlignment(.center)
                )
        }
        .padding(10)
    }
}








struct ErrorPageView: View {
    var body: some View {
        Text("Error!")
            .font(.largeTitle)
        Text("If you see this, the reel pages have not been setup correctly");
    }
}



struct Page0View: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [learnColors.color0, learnColors.color1]),
                startPoint: .init(x: 0.50, y: 0.00),
                endPoint: .init(x: 0.50, y: 1.00)
                    )
            .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Learn 🎓✏️")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .padding()
                
                    
                Spacer()
                
                MascotView(
                    withPicture: "greeting",
                    withText: "Let's learn together about water and how to save it!"
                )
                .padding(.bottom, 80.0)
                
                Spacer()
                
                Text("Scroll to see more")
                    .fontWeight(.bold)
                
                Image(systemName: "arrowshape.down.fill")
                    .font(.title)
                    .padding(.top, 6)
                    
                
                Spacer()
            }
        }
    }
}

struct Page1View: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [learnColors.color1, learnColors.color2]),
                startPoint: .init(x: 0.50, y: 0.00),
                endPoint: .init(x: 0.50, y: 1.00)
                    )
            .edgesIgnoringSafeArea(.all)
            VStack {
                
                MascotView(
                    withPicture: "teacher",
                    withText: "Let's start with some quizzes! How much water do you need to drink every day?"
                )
                QuizCardView(
                    options: ["1 liter", "2 liters", "3 liters", "4 liters"],
                    correctOptionIndex: 1
                )
            }
        }
        

    }
}

struct Page2View: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [learnColors.color2, learnColors.color3]),
                startPoint: .init(x: 0.50, y: 0.00),
                endPoint: .init(x: 0.50, y: 1.00)
                    )
            .edgesIgnoringSafeArea(.all)
            VStack {
                
                MascotView(
                    withPicture: "crying",
                    withText: "Did you know that water scarcity affects 40% of the world’s population?"
                )
                
                TextCardView(
                    txtBody: "700 million people are at-risk of being displaced as a result of drought by 2030.\n\nDroughts and desertification are serious environmental threats that are closely related? They can affect food production, health, and the environment. About 2.1 billion people lack access to safe drinking water at home"
                )
            }
        }
        

    }
}





struct Page3View: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [learnColors.color3, learnColors.color4]),
                startPoint: .init(x: 0.50, y: 0.00),
                endPoint: .init(x: 0.50, y: 1.00)
                    )
            .edgesIgnoringSafeArea(.all)
            VStack {
                
                MascotView(
                    withPicture: "steam",
                    withText: "Do you know how much water you use in a shower?"
                )
                // use the TextCardView component to display the information
                TextCardView(
                    title: "The average shower uses about 15 liters of water per minute.",
                    txtBody: "That means a 10-minute shower uses 150 liters of water! That's enough to fill up a large bathtub!"
                )
            }
        }
        

    }
}

struct Page4QuizView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [learnColors.color4, learnColors.color5]),
                startPoint: .init(x: 0.50, y: 0.00),
                endPoint: .init(x: 0.50, y: 1.00)
                    )
            .edgesIgnoringSafeArea(.all)
            VStack {
                // use the MascotView component to display the mascot and the question
                MascotView(
                    withPicture: "teacher",
                    withText: "Can you guess how much water on earth is available for human consumption?"
                )
                // use the QuizCardView component to display the options and the correct answer
                QuizCardView(
                    options: ["97%", "50%", "10%", "0.5%"],
                    correctOptionIndex: 3
                )
            }
        }
        

    }
}



struct Page4View: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [learnColors.color5, learnColors.color6]),
                startPoint: .init(x: 0.50, y: 0.00),
                endPoint: .init(x: 0.50, y: 1.00)
                    )
            .edgesIgnoringSafeArea(.all)
            VStack {
                
                MascotView(
                    withPicture: "green",
                    withText: "Why is saving water important?"
                )
                // use the TextCardView component to display the information
                TextCardView(
                    title: "Water is essential for life on Earth.",
                    txtBody: "It supports many ecosystems, agriculture, industry, and human health. However, water is a limited and precious resource. We need to use water wisely and avoid wasting it."
                )
            }
        }
        

    }
}

struct Page5View: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [learnColors.color6, learnColors.color7]),
                startPoint: .init(x: 0.50, y: 0.00),
                endPoint: .init(x: 0.50, y: 1.00)
                    )
            .edgesIgnoringSafeArea(.all)
            VStack {
                
                MascotView(
                    withPicture: "green",
                    withText: "What are some other benefits of taking shorter showers?"
                )
                // use the TextCardView component to display the information
                TextCardView(
                    title: "Taking shorter showers reduces your carbon footprint!",
                    txtBody: "You can save up to 15 kWh of energy per shower if you reduce your shower time by 5 minutes. That means you'll also reduce your carbon footprint!"
                )
            }
        }
        

    }
}

struct Page6View: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [learnColors.color7, learnColors.color8]),
                startPoint: .init(x: 0.50, y: 0.00),
                endPoint: .init(x: 0.50, y: 1.00)
                    )
            .edgesIgnoringSafeArea(.all)
            VStack {
                
                MascotView(
                    withPicture: "steam",
                    withText: "How can you take shorter showers?"
                )
                // use the TextCardView component to display the information
                TextCardView(
                    title: "Here are some tips:",
                    txtBody: "- First of all: continue using this app and try to challenge yourself! \n- Turn off the water while you shampoo, condition, soap, or shave. This can save up to 60 liters of water per shower.\n- Take a shower instead of a bath. A bath can use up to 250 liters of water!"
                )
            }
        }
        

    }
}



struct Page7View: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [learnColors.color8, learnColors.color9]),
                startPoint: .init(x: 0.50, y: 0.00),
                endPoint: .init(x: 0.50, y: 1.00)
                    )
            .edgesIgnoringSafeArea(.all)
            VStack {
                
                MascotView(
                    withPicture: "teacher",
                    withText: "Let's test your knowledge! Do you remember how much water does the average shower use per minute?"
                )
            
                // use the QuizCardView component to display the options and the correct answer
                QuizCardView(
                    options: ["10 liters", "15 liters", "20 liters", "25 liters"],
                    correctOptionIndex: 1
                )
            }
        }
        

    }
}

struct Page8View: View {
    
    @State var confettiCounter = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [learnColors.color9, learnColors.color10]),
                startPoint: .init(x: 0.50, y: 0.00),
                endPoint: .init(x: 0.50, y: 1.00)
                    )
            .edgesIgnoringSafeArea(.all)
            VStack {
                
                MascotView(
                    withPicture: "hearts",
                    withText: "Congratulations!!! "
                )
                // use the TextCardView component to display the message
                TextCardView(
                    title: "You have completed the learning section of the app.",
                    txtBody: "You have learned about the importance of saving water, and how to make it more effective. You have also tested your knowledge with a quiz. You are now ready to start saving water and making a difference!"
                )
                
                Button(action: {
                    self.confettiCounter += 1
                }) {
                    Text("Tap to celebrate 🎉🥳")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 5)
                        .padding(.horizontal, 45)
                        .scaleEffect(confettiCounter.isMultiple(of: 2) ? 1.05 : 1)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.6))
                }
                .confettiCannon(counter: $confettiCounter, confettis: [.text("💦"), .text("💙"), .text("💧"), .text("🌿")])

            }
        }
        

    }
}









