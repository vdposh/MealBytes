//
//  NutrientsToggleSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 18/07/2025.
//

import SwiftUI

struct NutrientsToggleSection: View {
    @Binding var toggleOn: Bool
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        SectionStyleContainer(
            mainContent: {
                Toggle(isOn: Binding(
                    get: { dailyIntakeViewModel.toggleOn },
                    set: {
                        dailyIntakeViewModel.restoreInputsIfNeeded()
                        dailyIntakeViewModel.toggleOn = $0
                    }
                )) {
                    Text("Macronutrient Metrics")
                }
                .toggleStyle(SwitchToggleStyle(tint: .customGreen))
            },
            layout: .pickerStyle,
            description: "Enable this option to calculate intake using macronutrients.",
            useWideTrailingPadding: true
        )
    }
}

#Preview {
    let mainViewModel = MainViewModel()
    let dailyIntakeViewModel = DailyIntakeViewModel(
        mainViewModel: mainViewModel
    )
    
    return NavigationStack {
        DailyIntakeView(dailyIntakeViewModel: dailyIntakeViewModel)
    }
}
