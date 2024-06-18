
import SwiftUI
import Foundation

class ViewModel_SignUP: ObservableObject {
    
    @Published var idForNewUser: String = ""
    @Published var nameForNewUser: String = ""
    @Published var pwForNewUser: String = ""
    
    @Published var checkingPW: Bool = false
    
    @Published var isAlreadyExist: Bool = false
        
    @Published var passwordValidationResult: [PasswordCondition] = []
    
    @Published var isFormWrong: Bool = false

    
    
    func successForNewAccount () {
        print("회원가입 성공 // success")
        print("""
              --------------------------------
                      N. E .W.    U. S. E. R
              
                        W. E. L. C. O. M. E
              
                        회원가입된 유저 데이터
              
                ID :   \(idForNewUser)
              NAME :   \(nameForNewUser)
                PW :   \(pwForNewUser)
              
              
              --------------------------------

              """)
    
    }
    
   
    func checkingPasswordCondition(_ password: String) -> [PasswordCondition]  {
        
        var results :[PasswordCondition] = []
        let minLength = 8
                let maxLength = 16
                
                if password.count < minLength {
                    results.append(.short)
                }
                
                if password.count > maxLength {
                    results.append(.long)
                }
                
                let upperCasePattern = ".*[A-Z]+.*"
                let lowerCasePattern = ".*[a-z]+.*"
                let numberPattern = ".*[0-9]+.*"
                let specialCharacterPattern = ".*[!@#$%^&*(),.?\":{}|<>]+.*"
                
                if !NSPredicate(format: "SELF MATCHES %@", upperCasePattern).evaluate(with: password) {
                    results.append(.nonUpperEng)
                }
                
                if !NSPredicate(format: "SELF MATCHES %@", lowerCasePattern).evaluate(with: password) {
                    results.append(.nonLowerEng)
                }
                
                if !NSPredicate(format: "SELF MATCHES %@", numberPattern).evaluate(with: password) {
                    results.append(.nonNumber)
                }
                
                if !NSPredicate(format: "SELF MATCHES %@", specialCharacterPattern).evaluate(with: password) {
                    results.append(.nonSpecialKey)
                }
                
                return results.isEmpty ? [.success] : results
        
        
    }
    func validPassword (_ password: String) {
        passwordValidationResult = checkingPasswordCondition(password)

    }
    
    func wrongForm () {
        
        if !idForNewUser.isEmpty && !nameForNewUser.isEmpty && !pwForNewUser.isEmpty && passwordValidationResult.contains(.success) {
            
            isFormWrong = false
            
        } else {
            
            isFormWrong = true
            
        }
    }
}



#Preview {
    View_SignUP(isCurrentModal: .constant(true))
}
