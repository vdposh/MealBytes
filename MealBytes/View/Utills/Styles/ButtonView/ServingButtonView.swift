//
//  ServingButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/03/2025.
//

import SwiftUI

struct ServingButtonView: View {
    let description: String
    let iconName: String
    let iconColor: Color = .accent.opacity(0.8)
    let servings: [Serving]
    let selectedServing: Serving
    let selection: (Serving) -> Void
    
    var body: some View {
        HStack {
            Label {
                Text(description)
            } icon: {
                Image(systemName: iconName)
                    .font(.system(size: 14))
                    .foregroundStyle(iconColor)
            }
            .labelIconToTitleSpacing(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("")
                .frame(maxWidth: 30, alignment: .trailing)
                .overlay(alignment: .trailing) {
                    Menu {
                        ForEach(servings, id: \.self) { serving in
                            Button {
                                selection(serving)
                            } label: {
                                Label {
                                    Text(serving.measurementDescription)
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
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
