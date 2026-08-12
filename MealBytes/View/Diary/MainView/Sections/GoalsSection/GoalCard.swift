//
//  GoalCard.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07.07.2026.
//

import SwiftUI

struct GoalCard: View {
    let title: String
    let value: String
    let progress: Double?
    var color: Color = .customCalories
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 26)
                .fill(Color(.secondarySystemGroupedBackground))
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.primary)
                    
                    Text(value)
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                }
                .lineLimit(1)
                .transaction { $0.animation = nil }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if let progress = progress {
                    ActivityRingView(progress: progress, mainColor: color)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
