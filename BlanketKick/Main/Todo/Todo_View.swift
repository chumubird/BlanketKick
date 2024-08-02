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
                    GradientStrokeTextField(gradient: LinearGradient(colors: [.pink,.purple], startPoint: .topLeading, endPoint: .bottomTrailing), placeholderValue: "Add Something To Do !", bindingValue: $textFieldValue)
                    
                 
                    
                    Button(action: {
                        if textFieldValue.isEmpty {
                            print("값을 입력하시오")
                        } else {
                            print("'\(textFieldValue)'")
                        }
                    }, label: {
                        
                        RoundedRectangle(cornerRadius: 25.0)
                            .frame(width: 90, height: 65)
                            .foregroundStyle(LinearGradient(colors: [.pink,.indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .opacity( textFieldValue.isEmpty ?  0.3 : 1.0)
                            .overlay(alignment: .center) {
                                Text("ADD")
                                    .foregroundStyle(.white)
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
