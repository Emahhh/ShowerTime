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




struct TikTokContentView: View {
    let pagesCount : Int = 4;
    @State private var currentPage = 0

    var body: some View {
        VerticalPager(pageCount: pagesCount, currentIndex: $currentPage) {
            ForEach(0..<pagesCount) { index in
                VStack{
                    Text("Page \(index)")
                    switch index {
                    case 0:
                        Page0View()
                    case 1:
                        Page1View()
                    case 2:
                        Page2View()
                    case 3:
                        Page3View()
                    default:
                        ErrorPageView()
                    }
                }
            }
        }

    }
}


struct QuizCardView: View {
    var question: String
    var options: [String]
    var correctOption: String
    @State private var selectedOption: String?
    @State private var showFeedback = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question)
                .font(.headline)
                .padding(.bottom, 5)

            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedOption = option
                    showFeedback = true
                }) {
                    HStack {
                        Image(systemName: selectedOption == option ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedOption == option ? .green : .primary)
                        Text(option)
                            .foregroundColor(.primary)
                    }
                }
                .disabled(showFeedback) // Disable buttons after feedback is shown
            }

            if showFeedback {
                Text(feedbackMessage)
                    .foregroundColor(feedbackColor)
                    .padding(.top, 10)

                if selectedOption != correctOption {
                    Button("Try Again", action: {
                        showFeedback = false
                        selectedOption = nil
                    })
                    .padding(.top, 10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
        .padding()
    }

    private var feedbackMessage: String {
        if selectedOption == correctOption {
            return "Correct!"
        } else {
            return "Wrong! Try again."
        }
    }

    private var feedbackColor: Color {
        return selectedOption == correctOption ? .green : .red
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






struct Page0View: View {
    var body: some View {
        Text("this is a pageeee")
        Text("Scroll to see more")
        Image(systemName: "arrowshape.down.fill")
            .font(.title)
            .padding(.top, 20)
    
    
    }
}

struct Page1View: View {
    var body: some View {
        QuizCardView(
            question: "Prova",
            options: ["prova1", "prova2", "prova3"],
            correctOption: "prova1"
        )
    }
}

struct Page2View: View {
    var body: some View {
        Text("Some different text")
            .font(.largeTitle)
    }
}

struct Page3View: View {
    var body: some View {
        QuizCardView(
            question: "Qual è la capitale dell'Italia?",
            options: ["Roma", "Pisa", "Poggibonsi"],
            correctOption: "Roma"
        )
    }
}


struct ErrorPageView: View {
    var body: some View {
        Text("Error!")
            .font(.largeTitle)
        Text("If you see this, the reel pages have not been setup correctly");
    }
}

