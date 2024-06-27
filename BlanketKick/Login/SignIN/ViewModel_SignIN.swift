
import SwiftUI
import Foundation

class ViewModel_SignIN: ObservableObject {
    
    
    
    @Published var isWaving = false

    @Published var idForLogin : String = ""
    @Published var pwForLogin : String = ""
    
    
    @Published var isRememberUser : Bool = false
    @Published var isSignUPmodal: Bool = false
            
    
    @ViewBuilder func Buttonforget () -> some View {

        Button(action: {
            
        }, label: {
            Text("Forget Password?")
                .foregroundStyle(.gray)
                .font(.system(size: 13))
        })
    }
}





#Preview {
    View_SignIN()
}
