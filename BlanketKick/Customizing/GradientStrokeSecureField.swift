
import SwiftUI

struct GradientStrokeSecureField: View {
    
    var gradient : LinearGradient
    @State var placeholderValue : String
    
    @Binding var bindingValue : String
    
    @State var isVisibleCode : Bool = false
    
    var body: some View {
        
        ZStack{
            if isVisibleCode == false {
                SecureField(placeholderValue, text: $bindingValue)
                    .padding()
                    .foregroundColor(.black)
                    .frame(width: 280, height: 60)
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(gradient,lineWidth:1)
                    }
                    .keyboardType(.emailAddress)
                    

                
            } else {
                TextField(placeholderValue, text: $bindingValue)
                    .padding()
                    .foregroundColor(.black)
                    .frame(width: 280, height: 60)
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(gradient,lineWidth:1)
                    }
                    .keyboardType(.emailAddress)

            }

                Button(action: {
                    isVisibleCode.toggle()
                }, label: {
                    Image(systemName: "eyes")
                        .fontWeight(.bold)
                        .foregroundStyle(isVisibleCode ? .green : . gray)
                }).offset(x: 100)
            
        }
    }
}

#Preview {
    GradientStrokeSecureField(gradient: LinearGradient(colors: [.red,.blue], startPoint: .leading, endPoint: .trailing), placeholderValue: "", bindingValue: .constant(""))
}
