//
//  OverviewSection.swift
//  MealBytes
//
//  Created by Porshe on 27/03/2025.
//

import SwiftUI

struct OverviewSection: View {
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 10) {
                Text("The RDI calculation is based on unique factors, including your age, weight, height, gender, and activity level.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 5)
                
                HStack {
                    Text(rdiViewModel.text(for: rdiViewModel.calculatedRdi))
                        .lineLimit(1)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(rdiViewModel.color(
                            for: rdiViewModel.calculatedRdi))
                }
            }
        }
        .padding(.horizontal)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }
}
