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
        Section {
        } footer: {
            VStack(alignment: .leading) {
                Text("The RDI calculation is based on unique factors, including age, weight, height, gender, and activity level.")
                    .padding(.bottom)
                
                Text(rdiViewModel.text(for: rdiViewModel.calculatedRdi))
                    .lineLimit(1)
                    .font(.headline)
                    .foregroundColor(rdiViewModel.color(
                        for: rdiViewModel.calculatedRdi))
            }
        }
    }
}

#Preview {
    let mainViewModel = MainViewModel()
    let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)

    return NavigationStack {
        RdiView(rdiViewModel: rdiViewModel)
    }
}
