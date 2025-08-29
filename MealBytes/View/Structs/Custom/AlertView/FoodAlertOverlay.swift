//
//  FoodAlertOverlay.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 25/08/2025.
//

import SwiftUI

struct FoodAlertOverlay: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        CustomAlertView(isVisible: $isVisible)
            .animation(.easeOut(duration: 0.3), value: isVisible)
    }
}

#Preview {
    PreviewContentView.contentView
}
