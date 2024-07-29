
import SwiftUI
import Foundation

import Combine

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class MainTab_ViewModel: ObservableObject {
    
    @Published var selectedTab: Int = 0

    //firebase
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    //combine
    var cancellables = Set<AnyCancellable>()
    
    
    @Published var userPhoto : UIImage?
    
    
    func loadUserPhoto (photoURLString : String) -> Future<UIImage,Error> {
        return Future { promise in
            let storageRef = self.storage.reference(forURL: photoURLString)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    promise(.failure(error))
                    print("Error loading photo: \(error.localizedDescription)")
                } else if let data = data, let uiImage = UIImage(data: data) {
                    promise(.success(uiImage))
                    print("유저 프로필 포토 이미지 다운로드 완료")
                } else {
                    promise(.failure(NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create UIImage from data"])))
                }
            }
            
            
        }
    }
    
    
    
    func loadUserPhotoOnItem () -> Future<Void, Error> {
        return Future { promise in
            guard let currentUser = Auth.auth().currentUser?.uid  else {
                return promise(.failure(NSError(domain: "UserAuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Current user is not authenticated."])))
            }
            self.db.collection("UserData").document(currentUser).getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                    print("Failed to load user data: \(error.localizedDescription)")
                    print("유저데이터 포토아이탬 불러오기 애러")
                    
                    
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
                    print("아이탬에 사진 불러오기 성공")
                    
                } else {
                    promise(.failure(NSError(domain: "DocumentError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
            
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    @ViewBuilder func itemForMain () -> some View {
        
        Button(action:  {
            self.selectedTab = 0
        } ) {
            VStack {
                Image(systemName: "1.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(Gradient(colors: selectedTab == 0 ? [.blue, .purple] : [.red,.orange]))
                Text("Tab 1")
                    .foregroundColor(selectedTab == 0 ? .blue : .gray)
                    .font(.system(size: 10))

            }
        }
    }
    
    @ViewBuilder func itemForUser () -> some View {
        
        if let uiImage = userPhoto {
            
            Button(action: {
                self.selectedTab = 1
            } ) {
                VStack {
                    Circle()
                        .overlay {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 25, height: 25)
                                .foregroundColor(selectedTab == 1  ? .red : .gray)
                        }
                        .frame(width: 30)
                        .foregroundStyle(.blue)
                   
                    Text("ME")
                        .foregroundColor(selectedTab == 1 ? .blue : .gray)
                        .font(.system(size: 10))

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
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                        .foregroundStyle(Gradient(colors: selectedTab == 1 ? [.blue, .purple] : [.red,.orange]))
                   
                    
                    Text("User")
                        .foregroundColor(selectedTab == 1 ? .blue : .gray)
                        .font(.system(size: 10))


                }
            }
        }
    }
    
    
}

#Preview {
    MainTab_View()
}
