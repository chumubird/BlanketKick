
import SwiftUI
import Foundation

class ViewModel_SignUP: ObservableObject {
    
    
    //main background animation
    @Published var isAnimation : Bool = false

    
    // main property for user data
    @Published var idForNewUser: String = ""
    @Published var nameForNewUser: String = ""
    @Published var pwForNewUser: String = ""
    
    // visible on off :  user pw
    @Published var checkingPW: Bool = false
    

     
    
    // checiking this id already exists or not
    @Published var alreadyExist: Bool = false
    
    // alert for checking id
    @Published var isAlertForCheckingID: Bool = false
    
    
    //  about validation of user id
    @Published var idUsable: Bool = false
    @Published var idChecking : Bool = false
    
    
    // about validation of user pw
    @Published var rangeMinMax : Bool = false
    @Published var hasNumber : Bool = false
    @Published var hasEngLowcase : Bool = false
    @Published var hasSpecialCharacter : Bool = false
    @Published var passwordCheckingDone : Bool = false
    
    
    // about newuser account complete and welcome alert
    @Published var alertForNewUser : Bool = false
    
   
    
    
    
    
    // 관리할 사용자 배열
      @Published var mockUsers: [Model_SignIN_SignUP] = [
          Model_SignIN_SignUP(id: "user1", password: "Password123!", name: "Alice"),
          Model_SignIN_SignUP(id: "user2", password: "SecurePass1@", name: "Bob"),
          Model_SignIN_SignUP(id: "user3", password: "TestUser#456", name: "Charlie"),
          Model_SignIN_SignUP(id: "user4", password: "ExamplePwd789$", name: "David"),
          Model_SignIN_SignUP(id: "user5", password: "DemoPass321#", name: "Eve")
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
        if idForNewUser.isEmpty {
            
            Image(systemName: "circle" )
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.gray)
                .offset(x: 80, y: 7)
                .onAppear(perform: {
                    self.idUsable = false
                    self.idChecking = false
                })
        } else {
            if idChecking == true {
                Image(systemName: alreadyExist ? "x.circle" : "checkmark.circle" )
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(idUsable ? .green : .gray)
                    .offset(x: 80, y: 7)
            }
            else {
                Image(systemName: "circle" )
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(idUsable ? .green : .gray)
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
    
    // filtering String for new user account data ( id name pw )
    func filteringStringForUserId (newValue: String) {
        let filteredValue = newValue.lowercased().filter { $0 >= "a" && $0 <= "z" || $0 >= "0" && $0 <= "9"}
        if filteredValue != newValue {
            idForNewUser = filteredValue
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
            self.idUsable = false
            self.idChecking = false
            self.idForNewUser = ""
            
        }))
    } else if idForNewUser.isEmpty == true {
        return Alert(title: Text("ID를 입력해주세요"), dismissButton: .cancel(Text("확인"), action: {
            self.idForNewUser = ""
            self.idUsable = false
            self.idChecking = false
        }))
    }else {
        return Alert(title: Text("사용가능한 ID 입니다."),message: Text("사용하시겠습니까?"), primaryButton: .default(Text("취소"), action: {
            self.idForNewUser = ""
            self.idUsable = false
            self.idChecking = false
        }), secondaryButton: .default(Text("사용하기"), action: {
            self.idUsable = true
            self.idChecking = true
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
              
                ID :   \(idForNewUser)
              NAME :   \(nameForNewUser)
                PW :   \(pwForNewUser)
              
              
              --------------------------------

              """)
        
        let newUser = Model_SignIN_SignUP(id: idForNewUser, password: pwForNewUser, name: nameForNewUser)
        mockUsers.append(newUser)
    }
}



#Preview {
    View_SignUP(isCurrentModal: .constant(true))
}
