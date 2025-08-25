//
//  FoodAlertOverlay.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 25/08/2025.
//

import SwiftUI

struct FoodAlertOverlay: View {
    @Binding var alertType: ActiveFoodAlertType?
    
    var body: some View {
        Group {
            if let type = alertType {
                switch type {
                case .added:
                    CustomAlertView(
                        isVisible: binding(for: .added),
                        style: .added
                    )
                case .saved:
                    CustomAlertView(
                        isVisible: binding(for: .saved),
                        style: .saved
                    )
                case .removed:
                    CustomAlertView(
                        isVisible: binding(for: .removed),
                        style: .removed
                    )
                }
            }
        }
        .animation(.easeOut(duration: 0.3), value: alertType)
    }
    
    private func binding(for type: ActiveFoodAlertType) -> Binding<Bool> {
        Binding(
            get: { alertType == type },
            set: { isVisible in alertType = nil
            }
        )
    }
}

enum ActiveFoodAlertType: Equatable {
    case added
    case saved
    case removed
}

#Preview {
    PreviewContentView.contentView
}
