import SwiftUI

struct MainTab_View: View {
    
  @StateObject var viewModel = MainTab_ViewModel()
    
    
    
    var body: some View {
        TabView {
            
            Text("Other Tab 1")
                .tabItem {
                    Label("Tab 1", systemImage: "1.square")
                }
            
            MyMapView()
                .tabItem {
                    Label("Tab 2", systemImage: "2.square")
                }
            User_View()
                .tabItem {
//                    Label("User", systemImage: "person")
                    viewModel.itemForUser()
                     
                }
        }
    }
}

#Preview {
    MainTab_View()
}
