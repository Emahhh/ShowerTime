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
    @State private var currentPage = 0
    
    let pageContentViews: [AnyView] = [
        AnyView(Page0View()),
        AnyView(Page1View()),
        AnyView(Page2View()),
        AnyView(Page3View()),
        AnyView(Page4View())
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
    var question: String
    var options: [String]
    var correctOptionIndex: Int
    @State private var selectedOptionIndex: Int?
    @State private var showFeedback = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question)
                .font(.headline)
                .padding(.bottom, 5)

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
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
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
            options: ["prova1", "risposta corretta", "prova3"],
            correctOptionIndex: 1
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
            correctOptionIndex: 0
        )
    }
}

struct Page4View: View {
    var body: some View {
        QuizCardView(
            question: "Quanto fa 2+2?",
            options: ["Un'anatra", "Un cervo", "Un pesce"],
            correctOptionIndex: 2
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

