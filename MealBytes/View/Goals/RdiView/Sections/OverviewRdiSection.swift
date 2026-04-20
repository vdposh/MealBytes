//
//  OverviewRdiSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct OverviewRdiSection: View {
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section {
            Text(rdiViewModel.text(for: rdiViewModel.calculatedRdi))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(
                    rdiViewModel.color(for: rdiViewModel.calculatedRdi)
                )
        } footer: {
            Text("The Recommended Daily Intake (RDI) calculation is based on unique factors, including age, weight, height, gender, and activity level. RDI is an estimate and not medical advice.")
        }
        .listRowBackground(Color.clear)
    }
}

#Preview {
    PreviewRdiView.rdiView
}
