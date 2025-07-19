//
//  ToggleSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 18/07/2025.
//

import SwiftUI

struct ToggleSection: View {
    @Binding var toggleOn: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $toggleOn) {
                Text("Macronutrient metrics")
            }
            .toggleStyle(SwitchToggleStyle(tint: .customGreen))
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            
            Text("Enable this option to calculate intake using macronutrients.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 25)
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
