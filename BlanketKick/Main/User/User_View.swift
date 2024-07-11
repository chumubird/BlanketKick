
import SwiftUI

struct User_View: View {
    
    @State var userPhoto : Image?
    
    @State var userEmail : String = "user Email"
    @State var userName : String = "user name"
    
    
    var body: some View {
        
        
        ZStack{
           
            VStack{
                
                VStack{
                    HStack{
                        Text("My Page")
                            .font(.title)
                            .fontWeight(.black)
                            .padding()
                        Spacer()
                        
                    }
                        
                }
                Spacer()
                    .frame(height: 100)
                
                
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .foregroundStyle(Gradient(colors: [.blue,.purple]))
                    .onAppear(perform: {
                    
                    })
                
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(.blue)
                    .background(.clear)
                    .frame(width: 230,height: 60)
                    .overlay {
                        GradientText(text: userEmail, gradient: LinearGradient(colors: [.blue,.purple], startPoint: .leading, endPoint: .trailing), fontSize: .headline)
                            
                    }
                    .padding(.top)
                
                
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(.blue)
                    .background(.clear)
                    .frame(width: 230,height: 60)
                    .overlay {
                        GradientText(text: userName, gradient: LinearGradient(colors: [.blue,.purple], startPoint: .leading, endPoint: .trailing), fontSize: .headline)
                            
                    }
                    .padding(.bottom)
                
                Spacer()
                

                
               

                
            }
        }
    }
}

#Preview {
    User_View()
}
