import SwiftUI
// pull done
struct MainTab_View: View {
    
    @StateObject var viewModel = MainTab_ViewModel()


    var body: some View {
        VStack {

            TabView(selection: $viewModel.selectedTab) {
                Text(" Tab 1")
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
            .offset(CGSize(width: 0, height: 15))
            
        }
        .onAppear(perform: {
            viewModel.selectedTab = 1
            viewModel.loadUserPhotoOnItem()
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Failed to load user data: \(error.localizedDescription)")

                    }
                }, receiveValue: {
                    print("탭바에 유저의 프로필사진을 성공적으로 불러왔습니다.")

                })
                .store(in: &viewModel.cancellables)
        })
    }
}
    
   



#Preview {
    MainTab_View()
}
