//
//  HeightSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct HeightSection: View {
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        NavigationLink {
            MeasurementSelectionView(
                value: $rdiViewModel.height,
                selectedUnit: $rdiViewModel.selectedHeightUnit,
                title: "Height",
                maxIntegerDigits: 3,
                normalizeAction: rdiViewModel.normalizeHeight
            )
        } label: {
            LabeledContent {
                if !rdiViewModel.height.isEmpty {
                    Text("\(rdiViewModel.height) \(rdiViewModel.selectedHeightUnit.rawValue)")
                }
            } label: {
                Text("Height")
            }
        }
    }
}

enum HeightUnit: String, CaseIterable {
    case cm = "cm"
    case inches = "inches"
}

#Preview {
    PreviewRdiView.rdiView
}
