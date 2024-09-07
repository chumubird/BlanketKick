
import SwiftUI
import Foundation
import Combine

import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


class ViewModel_SignIN: ObservableObject {
    
    //model
    @Published var user = User(email: "", name: "", password: "", profileImage: nil)

    
    @Published var isWaving = false

    
//    @Published var emailForLogin : String = ""
//    @Published var pwForLogin : String = ""
    
    
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
    
    
    //filtering for text && secure field
    
    func filteringStringForUserID (newValue : String) {
        //for email
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789@.")
        let filteredValue = newValue.lowercased().filter { Character in
            Character.unicodeScalars.first.map {
                allowedCharacters.contains($0) } ?? false
        } 
        if filteredValue != newValue {
            user.email = filteredValue
        }
    }
    
    func filterdStringForUserPw (newValue: String) {
        let filterdCharacter = newValue.lowercased().filter {
            $0 >= "a" && $0 <= "z" || $0 >= "0" && $0 <= "z" || $0 >= "!" && $0 <= "~"
        }
        if filterdCharacter != newValue {
            user.password = filterdCharacter
        }
    }
    
    
    
    
    
    
    // user Login with Firebase + combine

    func loginCombine () {
        Firebase.shared.userLogin(email: user.email, password: user.password)
            .flatMap { [weak self] authResult -> Future <Void, Error> in
//                guard let self = self , let uid = Auth.auth().currentUser?.uid else {
                guard let self = self else {

                    return Future { $0(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Self is nil"])))
                    }
                }
                let uid = authResult.user.uid
                return Firebase.shared.userLoginStatusData(uid: uid, loginStatus: userLoginStatus)
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



//
//
//#Preview {
//    View_SignIN(isLoggedIn: .constant(false))
//}
#Preview {
    View_SignIN()
        .environmentObject(AppStateForLoginLogOut())
}
