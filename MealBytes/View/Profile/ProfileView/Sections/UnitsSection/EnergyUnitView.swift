//
//  EnergyUnitView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07.10.2026.
//

import SwiftUI

struct EnergyUnitView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Picker("Energy", selection: Binding(
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

#Preview {
    PreviewProfileView.profileView
}
