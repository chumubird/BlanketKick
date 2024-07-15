//  commit after pull
import SwiftUI

struct User_View: View {
    
    
    let viewModel = User_ViewModel()
    
    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                VStack{
                    
                    HStack{
                        
                        viewModel.TextForTitle()
                        Spacer()
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
    }
}


#Preview {
    User_View()
}


