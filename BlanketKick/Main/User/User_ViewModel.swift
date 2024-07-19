// pull done 
// loading user data for user page with firebase works will start now
import SwiftUI
import Foundation
import Combine

class User_ViewModel: ObservableObject {
    
    
    @Published var userPhoto : Image?
    @Published var userEmail : String = "user Email"
    @Published var userName : String = "user Name"
    
    
    
    @ViewBuilder func TextForTitle () -> some View {
        Text("My Page")
            .font(.title)
            .fontWeight(.black)
            .padding()
    }
    
    @ViewBuilder func userProfilePhotoImage () -> some View {
        
        Image(systemName: "person.circle")
            .resizable()
            .scaledToFill()
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .foregroundStyle(Gradient(colors: [.blue,.purple]))
            .onAppear(perform: {
            })
        
    }
    
    @ViewBuilder func textForUserData ( someView : GradientText, padding : EdgeInsets ) -> some View {
        RoundedRectangle(cornerRadius: 25.0)
            .stroke(.blue)
            .background(.clear)
            .frame(width: 230,height: 60)
            .overlay {
                someView
            }
            .padding(padding)
    }
}





#Preview {
    User_View()
}
