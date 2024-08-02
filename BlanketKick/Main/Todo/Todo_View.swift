// pull done


import SwiftUI

struct Todo_View: View {
    
    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    @State var textFieldValue : String = ""
    
    var body: some View {
        
        ZStack{
            VStack{
                
                HStack{
                    
                    Text("My Page")
                        .font(.title)
                        .fontWeight(.black)
                        .padding()
                    Spacer()
                }
                
                Spacer()
                    .frame(height: 100)
                Image("pika")
                    .resizable()
                    .frame(width: 300,height: 250)
              
                
                
                Spacer()
                HStack{
                    GradientStrokeTextField(gradient: LinearGradient(colors: [.pink,.purple], startPoint: .topLeading, endPoint: .bottomTrailing), placeholderValue: "ToDo Value", bindingValue: $textFieldValue)
                    
                    Button(action: {
                        print(textFieldValue)
                    }, label: {
                        
                        RoundedRectangle(cornerRadius: 25.0)
                            .frame(width: 90, height: 65)
                            .foregroundStyle(Color(uiColor: .magenta))
                            .opacity(0.3)
                            .overlay(alignment: .center) {
                                Text("ADD")
                                    .foregroundStyle(.black)
                                    .fontWeight(.black)
                                    
                            }
                            
                        
                    })
                    
                }
                
            }
        }       
    }
}

#Preview {
    Todo_View()
}
