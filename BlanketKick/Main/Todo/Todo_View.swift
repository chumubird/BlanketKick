// pull done


import SwiftUI

struct Todo_View: View {
    
    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    @State var textFieldValue : String = ""
    
    var body: some View {
        
        
        
        VStack{
            
            
            Spacer()
            GradientStrokeTextField(gradient: LinearGradient(colors: [.pink,.purple], startPoint: .topLeading, endPoint: .bottomTrailing), placeholderValue: "ToDo Value", bindingValue: $textFieldValue)
            
        }
    }
}

#Preview {
    Todo_View()
}
