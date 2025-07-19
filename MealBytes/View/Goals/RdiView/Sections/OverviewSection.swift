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
        SectionStyleContainer(
            mainContent: {
                Text(rdiViewModel.text(for: rdiViewModel.calculatedRdi))
                    .foregroundColor(
                        rdiViewModel.color(for: rdiViewModel.calculatedRdi)
                    )
            }, layout: .resultStyle,
            title: "The Recommended Daily Intake (RDI) calculation is based on unique factors, including age, weight, height, gender, and activity level. RDI is an estimate and not medical advice.",
            useUppercasedTitle: false
        )
        .padding(.top, 40)
    }
}

#Preview {
    let mainViewModel = MainViewModel()
    let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)
    
    return NavigationStack {
        RdiView(rdiViewModel: rdiViewModel)
    }
}
