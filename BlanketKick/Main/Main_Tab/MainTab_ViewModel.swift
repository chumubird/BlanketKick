
import SwiftUI
import Foundation

import Combine

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

/// maintab viewmodel need fix or re work required



class MainTab_ViewModel: ObservableObject {
    
    //firebase
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    //combine
    var cancellables = Set<AnyCancellable>()
    
    
    @Published var userPhoto : UIImage?
    
    @ViewBuilder func itemForUser () -> some View {
        
        if let uiImage = userPhoto {
            VStack{
                Image(uiImage:  uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50,height: 50)
                
                Text("ME")
            }
        } else {
            VStack{
                Image(systemName: "person")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .foregroundStyle(Gradient(colors: [.blue, .purple]))
                    .background(.red)
                
                Text("?user?")
            }
        }
    }
  
    
    
}

#Preview {
    MainTab_View()
}
