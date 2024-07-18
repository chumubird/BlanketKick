import Foundation

import SwiftUI
import Combine

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

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
    
    // about user profile image with imagepicker
    
    @Published var showingImagePicker: Bool = false
    @Published var profileImage: UIImage?
    
    
    
    
    // about newuser account complete and welcome alert
    @Published var alertForNewUser : Bool = false
    
    
    @Published var isSignUpSuccessful: Bool = false
    @Published var errorMessage: String?
    
    
    private var cancellables = Set<AnyCancellable>()
    private let db = Firestore.firestore() // Firestore 인스턴스 생성
    private let storage = Storage.storage() // Firebase Storage 인스턴스 생성
    
    
    
    
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
    
    //     user id checking alert with 3 conditions
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
    }
    
    
    
    // Combine + firebase for checking New email already exists or not
//    func checkingEmailExist () ->  Future<Void, Error> {
//        return Future { promise in
//            let documentName = self.emailForNewUser
//            self.db.collection("EmailChecking").document(documentName).getDocument { userMail, error in
//                if let error = error {
//                    promise(.failure(error))
//                    print("처음부터 애러난거같음 이 애러라면 아마 규칙 어쩌고 지랄임")
//                }  else if let document = userMail, document.exists {
//                    promise(.success(()))
//                    print("이메일이 이미 존재함")
//                } else {
//                    promise(.success(()))
//                    print("이 이메일은 가입이 가능함")
//                    
//                }
//            }
//        }
//    }
    
    func checkingEmailExistWithCombine () {
        Firebase.shared.checkingEmailExist(documentName: emailForNewUser)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished :
                    print("호출성공")
                case .failure(let error) :
                    print(error)
                    print("애러난거같음")
                    
                }
                
            }, receiveValue: {_ in
                print("Email checking success")
            })
            .store(in: &cancellables)
    }
    
    
    
    // Combine + firebase for creating new user  on firebase Auth and uploading data ( user email for preventing that new user try to get email which already exists
    
    func createUserWithCombine( email: String, password: String) -> Future<AuthDataResult, Error> {
        return Future { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    print(error)
                    self.emailUsable = false
                    self.emailChecking = false
                    self.emailForNewUser = ""
                    self.pwForNewUser = ""
                    self.nameForNewUser = ""
                    
                } else if let authResult = authResult {
                    promise(.success(authResult))
                }
            }
        }
    }
    
    
    func addEmailDocumentFireStore () -> Future<Void, Error> {
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
    
//    func uploadProfileImage(uid: String) -> Future<String, Error> {
//        return Future { promise in
//            guard let image = self.profileImage,
//                  let imageData = image.jpegData(compressionQuality: 0.8) else {
////                promise(.failure(NSError(domain: "Invalid image", code: -1, userInfo: nil)))
//                promise(.success("")) // 빈 문자열 반환
//
//                return
//            }
//            
//            // Create a reference to 'UserProfilePhoto/UID/image.jpg'
//            let storageRef = self.storage.reference().child("user_profile_photo/\(uid)/image.jpg")
//            let metadata = StorageMetadata()
//            metadata.contentType = "image/jpeg"
//            
//            storageRef.putData(imageData, metadata: metadata) { metadata, error in
//                if let error = error {
//                    promise(.failure(error))
//                } else {
//                    storageRef.downloadURL { url, error in
//                        if let error = error {
//                            promise(.failure(error))
//                        } else if let url = url {
//                            promise(.success(url.absoluteString))
//                        }
//                    }
//                }
//            }
//        }
//    }
    
//    func getUserDataOnFireStoreDataBase (uid: String  , imgURL: String ) -> Future<Void, Error> {
//        return Future { [self] promise in
//            let mail = self.emailForNewUser
//            let name = self.nameForNewUser
//            let pw = self.pwForNewUser
//                        let photo = imgURL
//            db.collection("UserData").document(uid).setData(["email" : mail, "name" : name , "password" : pw , "photo" : photo ]) { error in
//                if let error = error {
//                    promise(.failure(error))
//                    print("문서가 없음")
//                    
//                } else {
//                    promise(.success(()))
//                    print("유저데이터 입력 승인")
//                }
//            }
//            
//        }
//    }
    
//    func putProfilePhotoDataOnUserData ( uid: String , imgURL: String) -> Future<Void, Error> {
//        
//        return Future { [self] promise in
//            let profilePhoto = imgURL
//            db.collection("UserData").document(uid).setData( ["Photo" : profilePhoto ]) { error in
//                if let error = error {
//                    promise(.failure(error))
//                } else {
//                    promise(.success(()))
//                }
//            }
//        }
//    }
    
    
    func signUPwithCombine () {
        
            createUserWithCombine(email: emailForNewUser, password: pwForNewUser)
                .flatMap { [weak self] authResult -> Future<Void, Error> in
                    guard let self = self else {
                        return Future { $0(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"]))) }
                    }
                    return addEmailDocumentFireStore()
                }
                .flatMap { [weak self] authResult -> Future<String, Error> in
                    guard let self = self , let uid = Auth.auth().currentUser?.uid else {
                        return Future { $0(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"]))) }
                    }
                    return Firebase.shared.getProfileImageOnStorage(uid: uid, image: profileImage)
                }
                .flatMap { [weak self] imgURL -> Future<Void, Error> in
                    guard let self = self , let uid = Auth.auth().currentUser?.uid else {
                        return Future { $0(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"]))) }
                    }
                    return Firebase.shared.getUserDataOnFireStoreDataBase(uid: uid, mail: emailForNewUser, name: nameForNewUser, pw: pwForNewUser, imgURL: imgURL)
                }
            
                .sink(receiveCompletion: {[weak self] completion in
                    switch completion {
                    case .finished:
                        self?.isSignUpSuccessful = true
                        self?.alertForNewUser = true
                        
                    case .failure(let error):
                        self?.isSignUpSuccessful = false
                        print(error)
                        self?.emailUsable = false
                        self?.emailChecking = false
                        self?.emailForNewUser = ""
                        self?.pwForNewUser = ""
                        self?.nameForNewUser = ""
                        
                    }
                },receiveValue: { authResult in
                    
                }
                )
                .store(in: &cancellables)
       
    }
    
    // auth logout method with combine + firebase
    
//    func authSignOut () -> Future<Void,Error> {
//        return Future { promise in
//            do {
//                try Auth.auth().signOut()
//                promise(.success(()))
//                print("auth 사용자 회원가입완료후 자동 로그인되는것을 로그아웃 시켜줌")
//                
//            } catch let authUserLogOut as NSError {
//                promise(.failure(authUserLogOut))
//                print("Error signing out: %@", authUserLogOut)
//                
//                
//            }
//        }
//    }
    func authLogOutWithCombine () {
        Firebase.shared.authSignOut()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished :
                    print("auth 로그아웃 성공")
                case .failure(let error) :
                    print(error)
                    print("auth  로그아웃 실패")
                }
            }, receiveValue: {
                
            })
            .store(in: &cancellables )
        
    }
    
    
    
}



#Preview {
    View_SignUP(isCurrentModal: .constant(true))
}
