import SwiftUI

struct MainTab_View: View {
    var body: some View {
        TabView {
            
            Text("Other Tab 1")
                .tabItem {
                    Label("Tab 1", systemImage: "1.square")
                }
            
            User_View()
                .tabItem {
                    Label("User", systemImage: "person")
                }
        }
    }
}

#Preview {
    MainTab_View()
}
