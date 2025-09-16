//
//  NutrientsToggleSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 18/07/2025.
//

import SwiftUI

struct NutrientsToggleSection: View {
    @Binding var toggleOn: Bool
    
    var body: some View {
        SectionStyleView(
            mainContent: {
                Toggle(isOn: $toggleOn) {
                    Text("Macronutrient Metrics")
                }
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            },
            layout: .pickerStyle,
            description: "Enable this option to calculate intake using macronutrients.",
            useWideTrailingPadding: true
        )
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
