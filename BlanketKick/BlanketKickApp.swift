//pull and commit

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
    
    @State private var isLoggedIn : Bool  = false
    
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTab_View()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                View_SignIN(isLoggedIn: $isLoggedIn)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
