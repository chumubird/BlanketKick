
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
    
    
    
    
}




//
//#Preview {
//    View_SignIN(isLoggedIn: .constant(false))
//}
