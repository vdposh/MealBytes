//
//  LinearProgressView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 18/05/2026.
//

import SwiftUI

struct LinearProgressView: View {
    let value: Double
    let height: CGFloat = 6
    var color: Color = .accent
    var backgroundColor: Color = Color(uiColor: .systemGray5)
    
    var body: some View {
        GeometryReader { geometry in
            Capsule()
                .fill(backgroundColor)
                .frame(width: geometry.size.width, height: height)
                .overlay(
                    Capsule()
                        .fill(color)
                        .frame(
                            width: geometry.size.width * value,
                            height: height
                        ),
                    alignment: .leading
                )
                .clipShape(Capsule())
        }
        .frame(height: height)
    }
}

#Preview {
    PreviewContentView.contentView
}
