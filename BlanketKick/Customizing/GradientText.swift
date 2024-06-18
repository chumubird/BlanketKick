
import SwiftUI

struct GradientText: View {
    var text: String
       var gradient: LinearGradient
    var fontSize : Font
       
       var body: some View {
           Text(text)
               .font(.headline)
               .foregroundColor(.clear)
               .overlay(
                   gradient
                       .mask(
                           Text(text)
                               .font(fontSize)
                       )
               )
       }
   }
#Preview {
    GradientText(text: "Gradient Text", gradient: LinearGradient(
        gradient: Gradient(colors: [Color.red, Color.blue]),
        startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/,
        endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/
    ), fontSize: .headline
    )
}

