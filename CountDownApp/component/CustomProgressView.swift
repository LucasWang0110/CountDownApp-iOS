//
//  CustomProgressView.swift
//  CountDown
//
//  Created by lucas on 2024/7/21.
//

import SwiftUI

struct CustomProgressView: View {
    
    var color: Color
    
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.5), lineWidth: 5)
            RingShape(progress: progress, thickness: 5)
                .fill(color)
        }
    
    }
}

struct RingShape: Shape {
    var progress: Double = 0.0
    var thickness: CGFloat = 30.0
    var startAngle: Double = -90
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: min(rect.width, rect.height) / 2.0,
                    startAngle: .degrees(startAngle),
                    endAngle: .degrees(360 * progress + startAngle), clockwise: false)
        return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
    }
}

#Preview {
    CustomProgressView(color: .green, progress: 0.6)
}
