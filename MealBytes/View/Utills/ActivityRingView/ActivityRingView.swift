//
//  ActivityRingView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30.06.2026.
//

import SwiftUI

struct ActivityRingView: View {
    let progress: Double
    var mainColor: Color = .customCalories
    var lineWidth: CGFloat = 7.5
    
    private var endColor: Color {
        mainColor.darker(by: 15)
    }
    
    private var startColor: Color {
        mainColor.lighter(by: 15)
    }
    
    private var backgroundColor: Color {
        mainColor.opacity(0.15)
    }
    
    private func overlapRotation() -> Angle {
        let overlapProgress = progress - 1.0
        let degrees = overlapProgress * 360.0
        return .degrees(-1 * degrees)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .stroke(backgroundColor, lineWidth: lineWidth)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [startColor, endColor]),
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        ),
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                
                Circle()
                    .frame(width: lineWidth, height: lineWidth)
                    .foregroundColor(startColor)
                    .offset(y: -1 * (geo.size.height / 2))
                    .opacity(progress > 0 ? 1 : 0)
            }
            .rotationEffect(overlapRotation())
            .scaleEffect(x: -1, y: 1)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
