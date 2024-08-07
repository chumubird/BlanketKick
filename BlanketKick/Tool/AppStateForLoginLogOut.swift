//pull from appstate
import SwiftUI
import Combine

class AppStateForLoginLogOut: ObservableObject {
    @Published var isLoggedIn: Bool = false
}
