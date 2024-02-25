import SwiftUI

struct MascotView: View {
    /// the selected image of droppy to be show
    @State var withPicture: String

    /// Custom text to be shown in the text bubble
    @State var withText = ""

    var body: some View {
        HStack {
            Image(withPicture) // Display the current emotion PNG
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .frame(width: 200, height: 60)
                    .shadow(radius: 4)
                Text(withText)
                    .foregroundColor(.white)
                    .padding()
            }

                
        }
        .padding()
    }
}

struct MascotView_Previews: PreviewProvider {
    static var previews: some View {
        MascotView(withPicture: "greeting", withText: "Hello World!")
    }
}
