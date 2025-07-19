//
//  OverviewSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct OverviewSection: View {
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        VStack {
            Text("The Recommended Daily Intake (RDI) calculation is based on unique factors, including age, weight, height, gender, and activity level. RDI is an estimate and not medical advice.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)
            
            Text(rdiViewModel.text(for: rdiViewModel.calculatedRdi))
                .font(.headline)
                .foregroundColor(
                    rdiViewModel.color(for: rdiViewModel.calculatedRdi)
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)
        }
        .padding(.top, 40)
        .padding(.bottom, 25)
    }
}

#Preview {
    let mainViewModel = MainViewModel()
    let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)
    
    return NavigationStack {
        RdiView(rdiViewModel: rdiViewModel)
    }
}
