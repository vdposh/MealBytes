//
//  ServingButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/03/2025.
//

import SwiftUI

struct ServingButtonView: View {
    let description: String
    let servings: [Serving]
    let selectedServing: Serving
    let selection: (Serving) -> Void
    let servingDescription: (Serving) -> String
    
    var body: some View {
        HStack {
            Label {
                Text(description)
            } icon: {
                Image(systemName: "fork.knife")
                    .font(.system(size: 14))
                    .foregroundStyle(.accent.opacity(0.8))
            }
            .labelIconToTitleSpacing(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Menu {
                ForEach(servings, id: \.self) { serving in
                    Button {
                        selection(serving)
                    } label: {
                        Label {
                            Text(servingDescription(serving))
                        } icon: {
                            if serving == selectedServing {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.accent.opacity(0.2))
                        .frame(width: 30, height: 30)
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.accent)
                }
            }
            .glassEffect(.regular.interactive())
            .buttonStyle(.borderless)
        }
        .frame(height: 20)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
