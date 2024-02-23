import SwiftUI


struct LearnView: View {
    var body: some View {
        TikTokContentView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




struct TikTokContentView: View {
    let pagesCount : Int = 3;
    @State private var currentPage = 0

    var body: some View {
        VerticalPager(pageCount: pagesCount, currentIndex: $currentPage) {
            ForEach(0..<pagesCount) { index in
                VStack{
                    Text("Page \(index)")
                    switch index {
                    case 0:
                        Page1View()
                    case 1:
                        Page2View()
                    case 2:
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
    @State private var selectedOption: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question)
                .font(.headline)
                .padding(.bottom, 5)

            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedOption = option
                }) {
                    HStack {
                        Image(systemName: selectedOption == option ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedOption == option ? .green : .primary)
                        Text(option)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
        .padding()
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






struct Page1View: View {
    var body: some View {
        Text("this is a pageeee")
    }
}

struct Page2View: View {
    var body: some View {
        QuizCardView(
            question: "Prova",
            options: ["prova1", "prova2", "prova3"]
        )
    }
}

struct Page3View: View {
    var body: some View {
        Text("Some different text")
            .font(.largeTitle)
    }
}


struct ErrorPageView: View {
    var body: some View {
        Text("Error!")
            .font(.largeTitle)
        Text("If you see this, the reel pages have not been setup correctly");
    }
}

