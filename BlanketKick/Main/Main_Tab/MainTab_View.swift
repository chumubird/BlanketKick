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
    let isSelected: Bool = false
   
    
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
             
                      Button(action:  {} ) {
                          VStack {
                              Image(systemName: "1.square")
                                  .resizable()
                                  .frame(width: 30, height: 30)
                                  .foregroundColor(isSelected ? .red : .gray)
                              Text("Tab 1")
                                  .foregroundColor(isSelected ? .red : .gray)
                          }
                      }
                      }
                      Spacer()

              Button(action: {} ) {
                  VStack {
                      Image(systemName: "person.circle")
                          .resizable()
                          .frame(width: 30, height: 30)
                          .foregroundColor(isSelected ? .red : .gray)
                      Text("User")
                          .foregroundColor(isSelected ? .red : .gray)
                  }
              }
                      Spacer()
                  }
                  .padding([.leading, .trailing])
                  .background(.clear)
                  .offset(CGSize(width: 0, height: 25))
                  
                  // Tab Content
              }
            
          }
    
   



#Preview {
    MainTab_View()
}
