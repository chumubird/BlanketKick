
import SwiftUI

struct GradientStrokeButton: View {
    
      var action: () -> Void
      var label: String
      var gradient: LinearGradient
      
      var body: some View {
          
//          Button(action: action) {

//              GradientText(text: label, gradient: LinearGradient(colors: [.green,.blue], startPoint: .leading, endPoint: .trailing), fontSize: .headline)
//                  .font(.headline)
//                  .padding()
//                  .background(.clear)
//                  .frame(width: 250)
//                  .overlay(
//                      RoundedRectangle(cornerRadius: 25)
//                          .stroke(gradient, lineWidth: 1)
//                          .background(.white)
//                          .frame(width: 300)
//                  )
//          }
          
          
          Button(action: action) {
              RoundedRectangle(cornerRadius: 25)
                  .stroke(gradient, lineWidth: 1)
                  .background(.clear)
                  .frame(width: 300,height: 50)
                  .overlay {
                      GradientText(text: label, gradient: LinearGradient(colors: [.green,.blue], startPoint: .leading, endPoint: .trailing), fontSize: .headline)
                          .font(.headline)
                          .padding()
                          .background(.clear)
                          .frame(width: 250)
                  }
          }
          
          
        
      }
}

#Preview {
    GradientStrokeButton(action: {},
                         label: "Login",
                         gradient: LinearGradient(colors: [.red,.blue],
                                                  startPoint: .leading,
                                                  endPoint: .trailing))
}
