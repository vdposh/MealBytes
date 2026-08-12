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
    var lineWidth: CGFloat = 6
    
    private var startColor: Color {
        mainColor.lighter(by: 10)
    }
    
    private var middleColor: Color {
        mainColor.lighter(by: 5)
    }
    
    private var backgroundColor: Color {
        mainColor.opacity(0.2)
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
                        AnyShapeStyle(
                            AngularGradient(
                                gradient: Gradient(
                                    colors: progress > 0.8
                                    ? [
                                        startColor,
                                        middleColor,
                                        mainColor
                                    ]
                                    : progress > 0 ? [mainColor] : [.clear]
                                ),
                                center: .center,
                                startAngle: .degrees(0),
                                endAngle: .degrees(360)
                            )
                        ),
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                
                if progress > 0.8 {
                    ZStack {
                        Circle()
                            .frame(width: lineWidth, height: lineWidth)
                            .foregroundColor(startColor)
                        
                        if progress > 0.93 {
                            Circle()
                                .trim(from: 0, to: 0.5)
                                .stroke(
                                    Color(.secondarySystemGroupedBackground),
                                    style: StrokeStyle(
                                        lineWidth: 5,
                                        lineCap: .round
                                    )
                                )
                                .clipShape(.circle)
                                .frame(
                                    width: lineWidth * 1.8,
                                    height: lineWidth * 1.8
                                )
                                .rotationEffect(.degrees(90))
                                .offset(x: 1)
                        }
                    }
                    .offset(y: -1 * (geo.size.height / 2))
                }
            }
            .rotationEffect(overlapRotation())
            .scaleEffect(x: -1, y: 1)
        }
        .frame(width: 30, height: 30)
    }
}

#Preview {
    PreviewContentView.contentView
}
