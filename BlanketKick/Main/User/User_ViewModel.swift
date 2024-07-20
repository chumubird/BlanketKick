// pull done
// loading user data for user page with firebase works will start now
import SwiftUI
import Foundation

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

import Combine

class User_ViewModel: ObservableObject {
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
     var cancellables = Set<AnyCancellable>()
    
    @Published var userPhoto : UIImage?
    @Published var userEmail : String = "user Email"
    @Published var userName : String = "user Name"
    
    @ViewBuilder func TextForTitle () -> some View {
        Text("My Page")
            .font(.title)
            .fontWeight(.black)
            .padding()
    }
    
    @ViewBuilder func userProfilePhotoImage () -> some View {
        if let uiImage = userPhoto {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .foregroundStyle(Gradient(colors: [.blue, .purple]))
        } else {
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .foregroundStyle(Gradient(colors: [.blue, .purple]))
        }
        
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
    
    func loadUserData() -> Future<Void, Error> {
           return Future { [weak self] promise in
               guard let currentUser = Auth.auth().currentUser?.uid else {
                   return promise(.failure(NSError(domain: "UserAuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Current user is not authenticated."])))
               }
               self?.db.collection("UserData").document(currentUser).getDocument { document, error in
                   if let error = error {
                       promise(.failure(error))
                       print("Failed to load user data: \(error.localizedDescription)")
                   } else if let document = document, document.exists {
                       self?.userEmail = document.get("email") as? String ?? "No Email"
                       self?.userName = document.get("name") as? String ?? "No Name"
                       
                       if let photoURLString = document.get("photo") as? String {
                           self?.loadUserPhoto(photoURLString: photoURLString)
                               .sink(receiveCompletion: { completion in
                                   if case .failure(let error) = completion {
                                       print("Failed to load photo: \(error.localizedDescription)")
                                   }
                               }, receiveValue: { [weak self] image in
                                   self?.userPhoto = image
                               })
                               .store(in: &self!.cancellables)
                       } else {
                           self?.userPhoto = nil
                       }
                       
                       promise(.success(()))
                   } else {
                       promise(.failure(NSError(domain: "DocumentError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                   }
               }
           }
       }
       
       func loadUserPhoto(photoURLString: String) -> Future<UIImage, Error> {
           return Future { promise in
               let storageRef = self.storage.reference(forURL: photoURLString)
               storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                   if let error = error {
                       promise(.failure(error))
                       print("Error loading photo: \(error.localizedDescription)")
                   } else if let data = data, let uiImage = UIImage(data: data) {
                       promise(.success(uiImage))
                   } else {
                       promise(.failure(NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create UIImage from data"])))
                   }
               }
           }
       }
   }





#Preview {
    User_View()
}
