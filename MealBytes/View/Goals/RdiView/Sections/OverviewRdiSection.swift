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
        SectionStyleView(
            mainContent: {
                Text(rdiViewModel.text(for: rdiViewModel.calculatedRdi))
                    .foregroundStyle(
                        rdiViewModel.color(for: rdiViewModel.calculatedRdi)
                    )
            },
            layout: .resultRdiStyle,
            title: "The Recommended Daily Intake (RDI) calculation is based on unique factors, including age, weight, height, gender, and activity level. RDI is an estimate and not medical advice."
        )
    }
}

#Preview {
    PreviewRdiView.rdiView
}
