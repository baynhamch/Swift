//
//  CircleSpinnerView.swift
//  Freqs Watch App
//
//  Created by Nicholas Conant-Hiley on 3/1/25.
//

import SwiftUI

struct CircleSpinnerView: View {
    let gredientColors:[Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    let circleWidth:CGFloat = 100
    
    @State var degrees:Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 25)
                .frame(width: circleWidth, height: circleWidth)
                .foregroundColor(.gray.opacity(0.3))
            
            Circle()
                .stroke(lineWidth: 25)
                .frame(width: circleWidth, height: circleWidth)
                .foregroundStyle(AngularGradient.init(gradient: Gradient(colors: gredientColors), center: .center))
                .mask {
                    Circle() .trim(from: 0, to: 0.25)
                        .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(degrees))
                }
            
        }
        .onAppear() {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                self.degrees += 360
            }
        }
    }
}

#Preview {
    CircleSpinnerView()
}
