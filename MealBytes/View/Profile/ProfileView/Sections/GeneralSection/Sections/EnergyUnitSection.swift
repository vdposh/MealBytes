//
//  EnergyUnitSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07.10.2026.
//

import SwiftUI

struct EnergyUnitSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Section {
            Picker("Energy Unit", selection: Binding(
                get: { profileViewModel.energyUnit },
                set: { newValue in
                    Task {
                        await profileViewModel.setEnergyUnit(newValue)
                    }
                }
            )) {
                ForEach(EnergyUnit.allCases, id: \.self) { unit in
                    Text(unit.title).tag(unit)
                }
            }
        }
    }
}

#Preview {
    PreviewProfileView.profileView
}
