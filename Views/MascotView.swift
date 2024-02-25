import SwiftUI


struct MascotView: View {
    /// The selected image of the mascot to be shown
    var withPicture : String

    /// Custom text to be shown in the speech bubble
    var withText : String

    var body: some View {
        if !withText.isEmpty {
            HStack {
                

                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white)
                        .frame(height: 100)
                        .shadow(radius: 5)
                        .overlay(
                            HStack{
                                Image(withPicture) // Display the current emotion PNG
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 90, height: 90)
                                    .cornerRadius(30)
                                
                                Text(withText)
                                    .lineLimit(4)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                    .padding()
                            },
                            

                            
                            alignment: .leading
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
