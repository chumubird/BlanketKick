
import SwiftUI


struct WavyRectangle: Shape {
   var waveHeight: CGFloat
   var frequency: CGFloat
   
   func path(in rect: CGRect) -> Path {
       var path = Path()
       
       // 상단 직선 부분
       path.move(to: CGPoint(x: rect.minX, y: rect.minY))
       path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
       
       // 우측 직선 부분
       path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - waveHeight))
       
       // 하단 물결 부분
       for x in stride(from: rect.maxX, to: rect.minX, by: -1) {
           let relativeX = x / rect.width
           let sine = sin(relativeX * frequency * .pi * 0.5)
           let y = rect.maxY - (sine * waveHeight + waveHeight)
           path.addLine(to: CGPoint(x: x, y: y))
       }
       
       // 좌측 직선 부분
       path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - waveHeight))
       
       path.closeSubpath()
       
       return path
   }
}

#Preview {
    WavyRectangle(waveHeight: 100, frequency: 4)
}
