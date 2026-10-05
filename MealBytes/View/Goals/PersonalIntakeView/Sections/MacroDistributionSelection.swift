//
//  MacroDistributionSelection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05.10.2026.
//

import SwiftUI

struct MacroDistributionSelection: View {
    @ObservedObject var personalIntakeViewModel: PersonalIntakeViewModel
    
    var body: some View {
        Section {
            Picker(
                "Distribution",
                selection: $personalIntakeViewModel.selectedDistribution
            ) {
                ForEach(
                    MacroDistribution.allCases,
                    id: \.self
                ) { distribution in
                    Text(distribution.rawValue)
                        .tag(distribution)
                }
            }
        }
    }
}

enum MacroDistribution: String, CaseIterable {
    case balanced = "Balanced"
    case lowCarbs = "Low Carbs"
    case highProtein = "High Protein"
    
    var protein: Double {
        switch self {
        case .balanced: 0.30
        case .lowCarbs: 0.35
        case .highProtein: 0.40
        }
    }
    
    var fat: Double {
        switch self {
        case .balanced: 0.20
        case .lowCarbs: 0.45
        case .highProtein: 0.25
        }
    }
    
    var carbs: Double {
        switch self {
        case .balanced: 0.50
        case .lowCarbs: 0.20
        case .highProtein: 0.35
        }
    }
}

#Preview {
    PreviewGoalsView.goalsView
}
