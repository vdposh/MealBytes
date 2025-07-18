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
        Section {
            Toggle(isOn: $toggleOn) {
                Text("Macronutrient metrics")
            }
            .toggleStyle(SwitchToggleStyle(tint: .customGreen))
        } footer: {
            Text("Enable this option to calculate intake using macronutrients.")
        }
    }
}
