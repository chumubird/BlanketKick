import SwiftUI

struct MainTab_View: View {
    
    @StateObject var viewModel = MainTab_ViewModel()
    
    
    var body: some View {
        ZStack{
            VStack {
                
                TabView(selection: $viewModel.selectedTab) {
                    Todo_View()
                        .tag(0)
                    //                    .background(.red)
                    User_View()
                        .tag(1)
                    //                    .background(.red)
                    
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
                viewModel.selectedTab = 0
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
            //        .background(.blue)
        }
    }
}
    
   



#Preview {
    MainTab_View()
}
