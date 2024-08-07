// pull done
// loading user data for user page with firebase works will start now
import SwiftUI
import Foundation

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

import Combine

class User_ViewModel: ObservableObject {
    
    //firebase
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    //combine
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
                    print("유저데이터 불러오기 이메일 이름 포토 가져오기 애러")
                } else if let document = document, document.exists {
                    self?.userEmail = document.get("email") as? String ?? "No Email"
                    self?.userName = document.get("name") as? String ?? "No Name"
                    
                    //  if photo field has only value = "" <---- when user didnt set photo for profile
                    // now app will not die and showing non proifle = default photo image on user view
                    if let photoURLString = document.get("photo") as? String, !photoURLString.isEmpty {
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
                    print("유저데이터 이메일 이름 프로필사진 불러오기 성공함")
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
                    print("유저 프로필 포토 이미지 다운로드 완료")
                } else {
                    promise(.failure(NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create UIImage from data"])))
                }
            }
        }
    }
    
    
    @Published var logOutSuccess : Bool = false

    func userLogOut () {
        Firebase.shared.userLogoutStatusData()
            .flatMap { _ in
                Firebase.shared.authSignOut()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("유저로그아웃 콤바인 성공")

                case .failure(let error):
                    
                    print("유저로그아웃 콤바인 애러")
                    print("Error CODE : \(error)")
                }
                
            }, receiveValue: {
                self.logOutSuccess = true
                print("로그아웃 성공 변수 : \(self.logOutSuccess.description)")
            })
            .store(in: &cancellables)
        
    }
    
    
}







#Preview {
    User_View()
}
