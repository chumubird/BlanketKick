import SwiftUI

struct MainTab_View: View {
    
    @StateObject var viewModel = MainTab_ViewModel()

    
    
    
    
    var body: some View {
        VStack {

            
            
            TabView(selection: $viewModel.selectedTab) {
                Text("Other Tab 1")
                    .tag(0)
                User_View()
                    .tag(1)
                
            }
            
            HStack {
                Spacer()
                
                viewModel.itemForMain()
               
                
                Spacer()
              
                viewModel.itemForUser()
                
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
