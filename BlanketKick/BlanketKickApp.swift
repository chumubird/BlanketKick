//
//  BlanketKickApp.swift
//  BlanketKick
//
//  Created by chul on 6/18/24.
//

import SwiftUI
// FireBase + SwiftUI
import FirebaseCore

// 앱델리게이트 클래스 작성후
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
   // 파이어베이스 초기화 설정
      FirebaseApp.configure()
    return true
  }
}
@main
struct BlanketKickApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            View_SignIN()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
