import Foundation
import SwiftUI



struct Model_SignIN_SignUP : Codable {
    
        var id: String
        var password: String
        var name: String?
    
}


//enum PasswordCondition : String {
//    case success = "비밀번호 확인 완료"
//    case short = "너무 짧습니다. 비밀번호는 최소 8자리 이상이어야합니다"
//    case long = "너무 깁니다. 비밀번호는 최대 16자리입니다."
//    case nonLowerEng = "영소문자가 포함되어야합니다."
//    case nonUpperEng = "영대문자가 포함되어야합니다."
//    case nonNumber = "숫자가 포함되어야합니다."
//    case nonSpecialKey = "특수문자를 포함해야합니다."
//}
//
//
//let mockUsers: [Model_SignIN_SignUP] = [
//    Model_SignIN_SignUP(id: "user1", password: "Password123!", name: "Alice"),
//    Model_SignIN_SignUP(id: "user2", password: "SecurePass1@", name: "Bob"),
//    Model_SignIN_SignUP(id: "user3", password: "TestUser#456", name: "Charlie"),
//    Model_SignIN_SignUP(id: "user4", password: "ExamplePwd789$", name: "David"),
//    Model_SignIN_SignUP(id: "user5", password: "DemoPass321#", name: "Eve")
//]

