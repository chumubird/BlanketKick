// pull done

import SwiftUI

struct User_View: View {
    
    @EnvironmentObject var appState: AppStateForLoginLogOut

    
    @StateObject var viewModel = User_ViewModel()

    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                VStack{
                    Spacer()
                        .frame(height: 60)
                    HStack{
                        
                        viewModel.TextForTitle()
                        Spacer()
                        
                        
                        Button(action: {
                            print("logout button clicked")
                            //firebase + combine logout logic
                                viewModel.userLogOut()
                            
                            if viewModel.logOutSuccess == true {
                                appState.isLoggedIn = false
                            }
                        }, label: {
                            VStack{
                                Image(systemName: "person.crop.circle.badge.minus")
                                    .resizable()
                                    .frame( width: 30 , height: 30)
                                    .foregroundStyle(.blue)
//                                    .padding()
                            }
                        })
                        Spacer()
                            .frame(width: 10)
                        
                    }
                }
                
                Spacer()
                    .frame(height: 100)
                
                
                
                //             user profile DATA
                //
                //                user Photo
                //
                //                user Email
                //
                //                user Name
                //
                
                
                viewModel.userProfilePhotoImage()
                
                viewModel.textForUserData(someView: GradientText(text: viewModel.userEmail, gradient: LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing), fontSize: .headline), padding: .init(top: 20, leading: 0, bottom: 0, trailing: 0))
                
                
                viewModel.textForUserData(someView: GradientText(text: viewModel.userName, gradient: LinearGradient(colors: [.blue,.purple], startPoint: .leading, endPoint: .trailing), fontSize: .headline), padding: .init(top: 0, leading: 0, bottom: 20, trailing: 0))
                
                Spacer()
            }
        }
        
        .onAppear {
            // 데이터 로드
            viewModel.loadUserData()
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Failed to load user data: \(error.localizedDescription)")
                    }
                }, receiveValue: {
                    print("접속한 유저의 데이터를 성공적으로 불러왔습니다.")
                })
                .store(in: &viewModel.cancellables)
        }
     
        
        .ignoresSafeArea()
    }
}

//
//#Preview {
//    User_View()
//}
//


#Preview {
    User_View()
        .environmentObject(AppStateForLoginLogOut())
}
