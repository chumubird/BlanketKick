import SwiftUI

struct MainTab_View: View {
    
  @StateObject var viewModel = MainTab_ViewModel()
    
    
    
    var body: some View {
        TabView {
            
            Text("Other Tab 1")
                .tabItem {
                    Label("Tab 1", systemImage: "1.square")
                }
            
            User_View()
                .tabItem {
//                    Label("User", systemImage: "person")
                    Image(systemName: "person.circle")
                        .resizable()
                        .foregroundStyle(.red)
                        .background(.red)
//                    viewModel.itemForUser()
                     
                }
        }
        .onAppear {
          print("Main tab view onAppear")
        }
    }
}

#Preview {
    MainTab_View()
}
