//
//  GradientStrokeTextField.swift
//  Blankick
//
//  Created by chul on 6/3/24.
//

import SwiftUI

struct GradientStrokeTextField: View {
    
    var gradient : LinearGradient
    @State var placeholderValue : String
    @Binding var bindingValue : String
    
    
    var body: some View {
        
        
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
}

#Preview {
    GradientStrokeTextField(gradient: LinearGradient(colors: [.red,.blue], startPoint: .leading, endPoint: .trailing), placeholderValue: "asdf", bindingValue: .constant(""))
}
