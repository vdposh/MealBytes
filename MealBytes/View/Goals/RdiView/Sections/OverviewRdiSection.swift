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
        } footer: {
            VStack(alignment: .leading) {
                Text("The Recommended Daily Intake (RDI) calculation is based on unique factors, including age, weight, height, gender, and activity level. RDI is an estimate and not medical advice.")
                    .padding(.bottom)
                
                Text(rdiViewModel.text(for: rdiViewModel.calculatedRdi))
                    .font(.headline)
                    .foregroundColor(
                        rdiViewModel.color(for: rdiViewModel.calculatedRdi)
                    )
            }
        }
    }
}

#Preview {
    PreviewRdiView.rdiView
}
