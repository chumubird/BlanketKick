
import SwiftUI
import Foundation

import Combine

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

/// maintab viewmodel need fix or re work required



class MainTab_ViewModel: ObservableObject {
    
    @Published var selectedTab: Int = 0

    
    
    //firebase
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    //combine
    var cancellables = Set<AnyCancellable>()
    
    
    @Published var userPhoto : UIImage?
    
    @ViewBuilder func itemForMain () -> some View {
        
        Button(action:  {
            self.selectedTab = 0
        } ) {
            VStack {
                Image(systemName: "1.square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Gradient(colors: selectedTab == 0 ? [.blue, .purple] : [.red,.orange]))
                Text("Tab 1")
                    .foregroundColor(selectedTab == 0 ? .blue : .gray)
            }
        }
    }
    
    
    
    @ViewBuilder func itemForUser () -> some View {
        
        if let uiImage = userPhoto {
            
            Button(action: {
                self.selectedTab = 1
            } ) {
                VStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(selectedTab == 1  ? .red : .gray)
                    Text("ME")
                        .foregroundColor(selectedTab == 1 ? .blue : .gray)
                }
            }
        } else {
            Button(action: {
                self.selectedTab = 1
            }) {
                VStack{
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .foregroundStyle(Gradient(colors: selectedTab == 1 ? [.blue, .purple] : [.red,.orange]))
                    
                    Text("?user?")
                        .foregroundColor(selectedTab == 1 ? .blue : .gray)

                }
            }
        }
    }
    
    
}

#Preview {
    MainTab_View()
}
