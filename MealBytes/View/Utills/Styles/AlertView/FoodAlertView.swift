//
//  FoodAlertView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 25/08/2025.
//

import SwiftUI

struct FoodAlertView: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        CustomFoodAlertView(isVisible: $isVisible)
            .animation(.easeOut(duration: 0.3), value: isVisible)
            .ignoresSafeArea()
    }
}

#Preview {
    PreviewContentView.contentView
}
