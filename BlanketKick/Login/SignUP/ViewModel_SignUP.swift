// pull from SignINandUP branch  2024 30th june 6:39 am
import SwiftUI
import Foundation
import FirebaseAuth
import Combine
import FirebaseFirestoreInternal

class ViewModel_SignUP: ObservableObject {
    
    
    //main background animation
    @Published var isAnimation : Bool = false
    
    
    // main property for user data
    @Published var emailForNewUser: String = ""
    @Published var nameForNewUser: String = ""
    @Published var pwForNewUser: String = ""
    
    // visible on off :  user pw
    @Published var checkingPW: Bool = false
    
    
    
    
    // checiking this id already exists or not
    @Published var alreadyExist: Bool = false
    
    // alert for checking id
    @Published var isAlertForCheckingID: Bool = false
    
    
    //  about validation of user id
    @Published var emailUsable: Bool = false
    @Published var emailChecking : Bool = false
    
    
    // about validation of user pw
    @Published var rangeMinMax : Bool = false
    @Published var hasNumber : Bool = false
    @Published var hasEngLowcase : Bool = false
    @Published var hasSpecialCharacter : Bool = false
    @Published var passwordCheckingDone : Bool = false
    
    
    // about newuser account complete and welcome alert
    @Published var alertForNewUser : Bool = false
    
    
    @Published var isSignUpSuccessful: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let db = Firestore.firestore() // Firestore 인스턴스 생성

    
    
    
    // 관리할 사용자 배열
    @Published var mockUsers: [Model_SignIN_SignUP] = [
        Model_SignIN_SignUP(email: "user1", password: "Password123!", name: "Alice"),
        Model_SignIN_SignUP(email: "user2", password: "SecurePass1@", name: "Bob"),
        Model_SignIN_SignUP(email: "user3", password: "TestUser#456", name: "Charlie"),
        Model_SignIN_SignUP(email: "user4", password: "ExamplePwd789$", name: "David"),
        Model_SignIN_SignUP(email: "user5", password: "DemoPass321#", name: "Eve")
    ]
    
    
    
    
    
    //viewbuilder
    
    @ViewBuilder func joinUsText () -> some View {
        Text("Join US")
            .padding(.bottom)
            .fontWeight(.black)
            .font(.system(size: 45))
            .foregroundStyle(.black)
            .fontDesign(.rounded)
            .fontWidth(Font.Width(100))
    }
    @ViewBuilder func profilePhotoImage () -> some View {
        Image(systemName: "person.circle")
            .resizable()
            .frame(width: 100,height: 100)
            .foregroundStyle(Gradient(colors: [.mint,.purple]))
            .overlay {
                Circle()
                    .background(.clear)
                    .foregroundStyle(.clear)
            }
    }
    
    @ViewBuilder func idCheckingImage () -> some View {
        if emailForNewUser.isEmpty {
            
            Image(systemName: "circle" )
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.gray)
                .offset(x: 80, y: 7)
                .onAppear(perform: {
                    self.emailUsable = false
                    self.emailChecking = false
                })
        } else {
            if emailChecking == true {
                Image(systemName: alreadyExist ? "x.circle" : "checkmark.circle" )
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(emailUsable ? .green : .gray)
                    .offset(x: 80, y: 7)
            }
            else {
                Image(systemName: "circle" )
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(emailUsable ? .green : .gray)
                    .offset(x: 80, y: 7)
                
            }
        }
    }
    
    @ViewBuilder func pwCheckBoxImage () -> some View {
        if rangeMinMax && hasNumber && hasEngLowcase && hasSpecialCharacter {
            Image(systemName: "checkmark.circle")
                .foregroundStyle(.green)
                .onAppear(perform: {
                    self.passwordCheckingDone = true
                })
        } else {
            Image(systemName: "circle")
                .foregroundStyle(.gray)
        }
        
    }
    
    @ViewBuilder func lengthConditionForCheckingPwText () -> some View {
        if pwForNewUser.count >= 6 && pwForNewUser.count <= 14 {
            Text("비밀번호: 길이 6자리에서 14자리")
                .foregroundStyle(.green)
            
            Image(systemName: "checkmark.circle")
                .foregroundStyle(.green)
                .onAppear(perform: {
                    self.rangeMinMax = true
                })
            
            Text(rangeMinMax.description)
                .foregroundStyle(.green
                )
        } else if pwForNewUser.isEmpty {
            
            Text("비밀번호는 6자리에서 14자리 까지")
                .foregroundStyle(.gray)
            
            Image(systemName: "questionmark.circle")
                .foregroundStyle(.gray)
                .onAppear(perform: {
                    self.rangeMinMax = false
                })
            
            Text(/*rangeMinMax.description*/"empty")
                .foregroundStyle(.gray)
        } else {
            Text("비밀번호: 길이는 6자리에서 14자리")
                .foregroundStyle(.red)
            
            Image(systemName: "x.circle")
                .foregroundStyle(.red)
                .onAppear(perform: {
                    self.rangeMinMax = false
                })
            
            Text(rangeMinMax.description)
                .foregroundStyle(.red)
        }
    }
    
    @ViewBuilder func numberConditionForPwText () -> some View {
        if pwForNewUser.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil {
            
            Text("비밀번호는 0~9숫자를 반드시 포함")
                .foregroundStyle(.green)
            
            Image(systemName: "checkmark.circle")
                .foregroundStyle(.green)
                .onAppear(perform: {
                    self.hasNumber = true
                })
            
            Text(rangeMinMax.description)
                .foregroundStyle(.green
                )
            
        }
        else if pwForNewUser.isEmpty{
            
            Text("비밀번호는 0~9숫자를 반드시 포함")
                .foregroundStyle(.gray)
            
            Image(systemName: "questionmark.circle")
                .foregroundStyle(.gray)
                .onAppear(perform: {
                    self.hasNumber = false
                })
            
            Text(/*rangeMinMax.description*/"empty")
                .foregroundStyle(.gray)
            
        } else {
            
            Text("비밀번호는 0~9숫자를 반드시 포함")
                .foregroundStyle(.red)
            
            Image(systemName: "x.circle")
                .foregroundStyle(.red)
                .onAppear(perform: {
                    self.hasNumber = false
                })
            
            Text(hasNumber.description)
                .foregroundStyle(.red)
            
        }
    }
    
    
    @ViewBuilder func lowcaseConditionForPwText () -> some View {
        if pwForNewUser.rangeOfCharacter(from: .lowercaseLetters) != nil {
            
            Text("비밀번호는 영소문자를 반드시 포함")
                .foregroundStyle(.green)
            
            Image(systemName: "checkmark.circle")
                .foregroundStyle(.green)
                .onAppear(perform: {
                    self.hasEngLowcase = true
                })
            
            
            Text(hasEngLowcase.description)
                .foregroundStyle(.green)
            
            
        } else if pwForNewUser.isEmpty {
            
            Text("비밀번호는 영소문자를 반드시 포함")
                .foregroundStyle(.gray)
            
            Image(systemName: "questionmark.circle")
                .foregroundStyle(.gray)
                .onAppear(perform: {
                    self.hasEngLowcase = false
                })
            
            Text(/*hasEngLowcase.description*/"empty")
                .foregroundStyle(.gray)
            
        } else {
            
            Text("비밀번호는 영소문자를 반드시 포함")
                .foregroundStyle(.red)
            
            Image(systemName: "x.circle")
                .foregroundStyle(.red)
                .onAppear(perform: {
                    self.hasEngLowcase = false
                })
            
            Text(hasEngLowcase.description)
                .foregroundStyle(.red)
        }
    }
    
    @ViewBuilder func specialCharacterText () -> some View {
        if pwForNewUser.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-={}[]|\\:;\"'<>,.?/`~")) != nil {
            
            Text("비밀번호는 특수문자를 반드시 포함")
                .foregroundStyle(.green)
            
            Image(systemName: "checkmark.circle")
                .foregroundStyle(.green)
                .onAppear(perform: {
                    self.hasSpecialCharacter = true
                })
            
            Text(hasEngLowcase.description)
                .foregroundStyle(.green)
            
            
        } else if  pwForNewUser.isEmpty {
            
            Text("비밀번호는 특수문자를 반드시 포함")
                .foregroundStyle(.gray)
            
            Image(systemName: "questionmark.circle")
                .foregroundStyle(.gray)
                .onAppear(perform: {
                    self.hasSpecialCharacter = false
                })
            
            Text(/*hasEngLowcase.description*/"empty")
                .foregroundStyle(.gray)
            
        } else {
            
            Text("비밀번호는 특수문자를 반드시 포함")
                .foregroundStyle(.red)
            
            Image(systemName: "x.circle")
                .foregroundStyle(.red)
                .onAppear(perform: {
                    self.hasSpecialCharacter = false
                })
            
            Text(hasEngLowcase.description)
                .foregroundStyle(.red)
            
        }
    }
    
    
    
    // func
    
    //     filtering String for new user account data ( id name pw )
    func filteringStringForUserId(newValue: String) {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789@.")
        let filteredValue = newValue.lowercased().filter { character in
            character.unicodeScalars.first.map { allowedCharacters.contains($0) } ?? false
        }
        if filteredValue != newValue {
            emailForNewUser = filteredValue
        }
    }
    func filteringStringForUserName (newValue: String) {
        let filteredValue = newValue.lowercased().filter { $0 >= "a" && $0 <= "z" || $0 >= "0" && $0 <=  "9" }
        if filteredValue != newValue {
            nameForNewUser = filteredValue
        }
    }
    
    func filteringStringForUserPw (newValue: String) {
        let filteredValue = newValue.lowercased().filter {  $0 >= "a" && $0 <= "z" || $0 >= "0" && $0 <= "9" || $0 >= "!" && $0 <= "~" }
        if filteredValue != newValue {
            pwForNewUser = filteredValue
        }
    }
    
    // user id checking alert with 3 conditions
    func alertAlreadyExsitsId () -> Alert {
        if alreadyExist == true {
            return Alert(title: Text("이미 존재하는 ID 입니다."),dismissButton: .cancel(Text("확인"), action: {
                self.emailUsable = false
                self.emailChecking = false
                self.emailForNewUser = ""
                
            }))
        } else if emailForNewUser.isEmpty == true {
            return Alert(title: Text("ID를 입력해주세요"), dismissButton: .cancel(Text("확인"), action: {
                self.emailForNewUser = ""
                self.emailUsable = false
                self.emailChecking = false
            }))
        }else {
            return Alert(title: Text("사용가능한 ID 입니다."),message: Text("사용하시겠습니까?"), primaryButton: .default(Text("취소"), action: {
                self.emailForNewUser = ""
                self.emailUsable = false
                self.emailChecking = false
            }), secondaryButton: .default(Text("사용하기"), action: {
                self.emailUsable = true
                self.emailChecking = true
            }))
        }
    }
    
    // done button click event
    func successForNewAccount () {
        print("회원가입 성공 // success")
        print("""
              --------------------------------
                      N. E .W.    U. S. E. R
              
                        W. E. L. C. O. M. E
              
                        회원가입된 유저 데이터
              
                ID :   \(emailForNewUser)
              NAME :   \(nameForNewUser)
                PW :   \(pwForNewUser)
              --------------------------------
              """)
        
        let newUser = Model_SignIN_SignUP(email: emailForNewUser, password: pwForNewUser, name: nameForNewUser)
        mockUsers.append(newUser)
    }
    
    // Firebase createUser를 Combine Future로 래핑
    func createUserWithCombine(withEmail email: String, password: String) -> Future<AuthDataResult, Error> {
        return Future { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    print(error)
                } else if let authResult = authResult {
                    promise(.success(authResult))
                }
            }
        }
    }
    
//    func checkingUserEmailWithFirebase (_ email : String) {
//        
//    }
//    
    // 이메일을 Firestore에 등록하는 함수
//      func checkingUserEmailWithFirebase1(_ email: String) {
//          let documentID = UUID().uuidString // 문서 ID를 UUID로 생성
//
//          // 이메일을 Firestore의 EmailChecking 컬렉션에 추가
//          db.collection("EmailChecking").document(documentID).setData(["email": email]) { error in
//              if let error = error {
//                  print("Error adding document: \(error.localizedDescription)")
//              } else {
//                  print("Document successfully added with ID: \(documentID)")
//              }
//          }
//      }
//    
    // 이메일을 Firestore에 등록하는 함수 (Combine 사용)
//    func checkingUserEmailWithCombine(_ email: String) -> Future<Void, Error> {
//        return Future { [self] promise in
//                let documentID = UUID().uuidString // 문서 ID를 UUID로 생성
//                db.collection("EmailChecking").document(documentID).setData(["email": email]) { error in
//                    if let error = error {
//                        promise(.failure(error))
//                    } else {
//                        promise(.success(()))
//                    }
//                }
//            }
//        }
//    
    func checkchcek () -> Future<Void, Error> {
        return Future { [self] promise in
            let userMail = self.emailForNewUser
            db.collection("EmailChecking").document(userMail).setData(["email" : userMail]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }
    
    // 회원가입 함수
//    func signUp() {
//        
//        createUser(withEmail: emailForNewUser, password: pwForNewUser)
//            .map { _ in true }
//            .catch { [weak self] error -> Just<Bool> in
//                self?.errorMessage = error.localizedDescription
//                return Just(false)
//            }
//            .assign(to: \.isSignUpSuccessful, on: self)
//            .store(in: &cancellables)
//    }
    
    func signUPwithCombine () {
        createUserWithCombine(withEmail: emailForNewUser, password: pwForNewUser)
            .flatMap { [weak self] authResult -> Future<Void, Error> in
                guard let self = self else {
                    return Future { $0(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"]))) }
                }               
                return checkchcek()
            }

        
            .sink(receiveCompletion: {[weak self] completion in
                switch completion {
                case .finished:
                    self?.isSignUpSuccessful = true
                    
                case .failure(let error):
                    self?.isSignUpSuccessful = false
                }
            },receiveValue: {   authResult in
                
            }
            )
            .store(in: &cancellables)
    }
}



#Preview {
    View_SignUP(isCurrentModal: .constant(true))
}
