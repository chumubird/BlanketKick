// pull done


import SwiftUI

struct Todo_View: View {
    
    
    @State var textFieldValue : String = ""
    
    @State var items : [String] = []
    
    
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
//                Image("pika")
//                    .resizable()
//                    .frame(width: 300,height: 250)
//
                
                
                Button(action: {
                    
                }
                       , label: {
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(width: 120, height: 120)
                        .foregroundStyle(LinearGradient(colors: [.pink,.indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .opacity( items.isEmpty ?  0.3 : 1.0)
                        .overlay(alignment: .center) {
                            Text("Check Your TODO")
                                .foregroundStyle(.white)
                                .fontWeight(.black)
                                .font(.system(size: 30))
                        }
                    
                  
                })
                .disabled(items.isEmpty ? true : false)
                
//                ForEach($items) { items in
//                    Button {
//                        
//                    } label: {
//                        Text(items)
//                    }
//
//                }
                List {
                                   ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                                       Button(action: {
                                           // Item action
                                       }) {
                                           HStack{
                                               Text(item)
                                               Spacer()
                                               Image(systemName: "trash")
                                                   .onTapGesture {
                                                       print("delete Button clicked!")
                                                   }
                                           }
                                       }
                                   }
                               }

                
                
                Spacer()
                HStack{
                    GradientStrokeTextField(gradient: LinearGradient(colors: [.pink,.purple], startPoint: .topLeading, endPoint: .bottomTrailing), placeholderValue: "Add Something To Do !", bindingValue: $textFieldValue)
                    
                    Button(action: {
                        if textFieldValue.isEmpty {
                            print("값을 입력하시오")
                        } else if  items.count >= 10 {
                            print("10가지 할일을 먼저 끝내셔야합니다.")
                            
                        } else {
                            print("Todo List 에 '\(textFieldValue)' 을 추가합니다.")
                            items.append(textFieldValue)
                            print("""
                                    Todo List 항목 수 : \(items.count.description)
                                    Todo List 에 \(items) 항목들이 있습니다.
                                    """)
                            textFieldValue = ""
                            print("Todo TextFiled Clear for Next Value")
                            
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
