import SwiftUI
//
//struct MainTab_View: View {
//    
//  @StateObject var viewModel = MainTab_ViewModel()
//    
//    
//    
//    var body: some View {
//        TabView {
//            
//            Text("Other Tab 1")
//                .tabItem {
//                    Label("Tab 1", systemImage: "1.square")
//                }
//            
//            User_View()
//                .tabItem {
////                    Label("User", systemImage: "person")
//                    Image(systemName: "person.circle")
//                        .resizable()
//                        .foregroundStyle(.red)
//                        .background(.red)
////                    viewModel.itemForUser()
//                     
//                }
//        }
//        .onAppear {
//          print("Main tab view onAppear")
//        }
//    }
//}



struct MainTab_View: View {
    
  @StateObject var viewModel = MainTab_ViewModel()
    @State private var selectedTab: Int = 0

    
    var body: some View {
          VStack {
              // Custom Tab Bar
            
              TabView(selection: $selectedTab) {
                  Text("Other Tab 1")
                      .tag(0)
                  User_View()
                      .tag(1)
              }
              
                  HStack {
                      Spacer()
                      TabBarButton(title: "Tab 1", imageName: "1.square", isSelected: selectedTab == 0) {
                          selectedTab = 0
                      }
                      Spacer()
                      TabBarButton(title: "User", imageName: "person.circle", isSelected: selectedTab == 1) {
                          selectedTab = 1
                      }
                      Spacer()
                  }
                  .padding([.leading, .trailing])
                  .background(.clear)
                  .offset(CGSize(width: 0, height: 25))
                  
                  // Tab Content
              }
            
          }
      }
    
    
    struct TabBarButton: View {
        let title: String
        let imageName: String
        let isSelected: Bool
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                VStack {
                    Image(systemName: imageName)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(isSelected ? .red : .gray)
                    Text(title)
                        .foregroundColor(isSelected ? .red : .gray)
                }
            }
        }
    }




#Preview {
    MainTab_View()
}
