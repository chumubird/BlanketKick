
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
//                    .clipShape(Circle())
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
  
    
    
    func loadUserPhotoForitem () -> Future<Void,Error> {
        return Future { promise in
            guard let currentUser = Auth.auth().currentUser?.uid else {
                return promise(.failure(NSError(domain: "UserAuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Current user is not authenticated."])))
            }
            self.db.collection("UserData").document(currentUser).getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                    print("Failed to load user data: \(error.localizedDescription)")
                    print("유저데이터 불러오기  가져오기 애러")     
                } else if let document = document, document.exists {
                    
                    if let photoURLString = document.get("photo") as? String, !photoURLString.isEmpty {
                        self.loadUserPhoto(photoURLString: photoURLString)
                            .sink(receiveCompletion: { completion in
                                if case .failure(let error) = completion {
                                    print("Failed to load photo: \(error.localizedDescription)")
                                }
                            }, receiveValue: { image in
                                self.userPhoto = image
                                
                            })
                            .store(in: &self.cancellables)
                    } else {
                        self.userPhoto = nil
                    }
                        
                        promise(.success(()))
print("success")
                        
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
                    print("아이탬 포토 이미지 다운로드 완료")
                } else {
                    promise(.failure(NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create UIImage from data"])))
                }
            }
        }
    }
    
    }

#Preview {
    MainTab_View()
}
