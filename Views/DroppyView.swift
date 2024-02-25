import SwiftUI


struct MascotView: View {
    /// The selected image of the mascot to be shown
    @State var withPicture: String

    /// Custom text to be shown in the speech bubble
    @State var withText = ""

    var body: some View {
        if !withText.isEmpty {
            HStack {
                Image(withPicture) // Display the current emotion PNG
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 90, height: 90)

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(height: 100)
                        .shadow(radius: 4)
                        .overlay(
                            Text(withText)
                                .lineLimit(4)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding()
                        )
                }
                .multilineTextAlignment(.leading)
            }
            .padding(.trailing, 2.0)
            .padding(8.0)
        }
        
    }
}






struct MascotView_Previews: PreviewProvider {
    static var previews: some View {
        MascotView(withPicture: "greeting", withText: "Hello, I'm your friendly mascot!Hello, I'm your friendly mascot!Hello, I'm your friendly mascot!Hello, I'm your friendly mascot!")
    }
}
