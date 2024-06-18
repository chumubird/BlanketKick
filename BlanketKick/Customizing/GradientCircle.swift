//
//  GradientCircle.swift
//  Blankick
//
//  Created by chul on 6/3/24.
//

import SwiftUI

    struct GradientCircle: View {
           var gradient: LinearGradient
        var size: CGFloat
        
           var body: some View {
               Circle()
                   .fill(gradient)
                   .frame(width: size, height: size)
                      
           }
       }

#Preview {
    GradientCircle(gradient: LinearGradient(colors: [.red,.blue], startPoint: .leading, endPoint: .trailing), size: 100)
}
