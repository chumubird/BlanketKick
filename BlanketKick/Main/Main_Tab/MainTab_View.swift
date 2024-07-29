import SwiftUI

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
                
                Button(action:  {
                    selectedTab = 0
                } ) {
                    VStack {
                        Image(systemName: "1.square")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor( selectedTab == 0 ? .red : .gray)
                        Text("Tab 1")
                            .foregroundColor( selectedTab == 0 ? .red : .gray)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    selectedTab = 1
                } ) {
                    VStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(selectedTab == 1  ? .red : .gray)
                        Text("User")
                            .foregroundColor(selectedTab == 1 ? .red : .gray)
                    }
                }
                Spacer()
            }
            .padding([.leading, .trailing])
            .background(.clear)
            .offset(CGSize(width: 0, height: 25))
            
        }
        
    }
}
    
   



#Preview {
    MainTab_View()
}
