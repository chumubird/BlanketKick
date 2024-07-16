
import SwiftUI
import Foundation
import Combine

import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


class ViewModel_SignIN: ObservableObject {
    
    @Published var isWaving = false

    
    @Published var emailForLogin : String = ""
    @Published var pwForLogin : String = ""
    
    
    @Published var userLoginStatus : Bool = false
    
    @Published var isLoggedIn: Bool = false // 추가



    @Published var isRememberUser : Bool = false
    @Published var isSignUPmodal: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    
    @ViewBuilder func Buttonforget () -> some View {

        Button(action: {
            
        }, label: {
            Text("Forget Password?")
                .foregroundStyle(.gray)
                .font(.system(size: 13))
        })
    }
    
    
    // user Login with Firebase + combine
    
    func userLogin () -> Future<AuthDataResult, Error> {
        return Future { [self] promise in
            Auth.auth().signIn(withEmail: emailForLogin, password: pwForLogin) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    print(error)
                    print("firebase for login with auth 호출 실패")
                    
                } else if let authResult = authResult {
                    promise(.success(authResult))
                    print(authResult)
                    print("firebase for login with auth 호출완료")
                }
            }
        }
    }
    
    // after login userdata get new data field for login time : timer  and login status : Bool ( off -> on )
    
    func afterLoginGetData (uid: String) -> Future<Void,Error> {
        return Future { [self] promise in
            var loginStatus = userLoginStatus
            loginStatus = true
            db.collection("UserData").document(uid).updateData(["Login_Status" : loginStatus]) { error in
                if let error = error {
                    promise(.failure(error))
                    print(error)
                    print("문서가 없음 // 애러")
                } else {
                    promise(.success(()))
                            print("로그인 상태 업데이트 완료 off -> on")
                }
            }
        }
    }
    
    func loginCombine () {
        userLogin()
            .flatMap { [weak self] authResult -> Future <Void, Error> in
//                guard let self = self , let uid = Auth.auth().currentUser?.uid else {
                guard let self = self else {

                    return Future { $0(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Self is nil"])))
                    }
                }
                let uid = authResult.user.uid
                return afterLoginGetData(uid: uid)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("login + combine success")
                    
                    self.isLoggedIn = true // 로그인 성공 시 isLoggedIn을 true로 설정


                case .failure(let error):
                    print("login + combine error")
                    print(error)
                }
                
            }, receiveValue: {
               
            })
            .store(in: &cancellables)
    }
    
    
    
    
}





#Preview {
    View_SignIN(isLoggedIn: .constant(false))
}
