//
//  Firebase.swift
//  BlanketKick
//
//  Created by chul on 7/18/24.
//

import SwiftUI
import Foundation

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

import Combine

class Firebase: ObservableObject {
    
    static let shared = Firebase()

    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    
    func checkingEmailExist(documentName: String) -> Future<Void,Error> {
        return Future { [self] promise in
            let documentName = documentName
            db.collection("EmailCheking").document(documentName).getDocument {
                userEmail, error in
                if let error = error {
                    promise(.failure(error))
                    print("처음부터 애러난거같음 이 애러라면 아마 규칙 어쩌고 지랄임")

                }else if let document = userEmail, document.exists {
                    promise(.success(()))
                    print("이메일이 이미 존재함")
                } else {
                    promise(.success(()))
                    print("이 이메일은 가입이 가능함")
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // For Login
    // user Login with Firebase + combine method
    // login with firebase auth
    // after passig auth   user login status - > true (currently its logged in now  as bool value )
    // and console shows which user is logged in ( current user )
    
    func currentUser () {
        if let user = Auth.auth().currentUser {
                let uid = user.uid
                let email = user.email ?? "이메일 없음"
                print("현재 로그인한 사용자 UID: \(uid)")
                print("현재 로그인한 사용자 이메일: \(email)")
            } else {
                print("현재 로그인한 사용자가 없습니다.")
            }
    }
    
    func userLogin (email: String, password: String) -> Future<AuthDataResult, Error> {
        return Future { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
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
    
    func userLoginStatusData (uid: String, loginStatus: Bool) -> Future<Void,Error> {
        return Future { [self] promise in
            var loginStatus = loginStatus
            loginStatus = true
            db.collection("UserData").document(uid).updateData(["Login_Status" : loginStatus]) { error in
                if let error = error {
                    promise(.failure(error))
                    print(error)
                    print("문서가 없음 // 애러")
                } else {
                    promise(.success(()))
                    print("로그인 상태 업데이트 완료 off -> on")
                    print("--------- 지금 로그인 한 유저 ---------")
                    self.currentUser()
                }
            }
        }
    }
    
    // auth logout method with combine + firebase

    func authSignOut () -> Future<Void,Error> {
        return Future { promise in
            do{
                try Auth.auth().signOut()
                promise(.success(()))
                print("auth 사용자 회원가입완료후 자동 로그인되는것을 로그아웃 시켜줌")
            } catch let authUserLogOut as NSError {
                promise(.failure(authUserLogOut))
                print("Error signing out : %@", authUserLogOut)
            }
        }
    }
    
    
    
    
    
    
    
}


