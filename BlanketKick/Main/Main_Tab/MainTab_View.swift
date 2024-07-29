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
        .onAppear {
            // 데이터 로드
            viewModel.loadUserPhotoForitem()
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Failed to load user data: \(error.localizedDescription)")
                    }
                }, receiveValue: {
                    print("접속한 유저의 데이터를 성공적으로 불러왔습니다.")
                })
                .store(in: &viewModel.cancellables)
        }
    }
}

#Preview {
    MainTab_View()
}
