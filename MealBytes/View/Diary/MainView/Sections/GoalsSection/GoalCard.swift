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
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 24)
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
                    ActivityRingView(progress: progress)
                }
            }
            .padding()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
