//
//  PreviewGoalsView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/09/2025.
//

import SwiftUI

struct PreviewGoalsView {
    static var goalsView: some View {
        let mainViewModel = MainViewModel()
        let macrosIntakeViewModel = MacrosIntakeViewModel(
            mainViewModel: mainViewModel)
        let personalIntakeViewModel = PersonalIntakeViewModel(
            mainViewModel: mainViewModel
        )
        let customIntakeViewModel = CustomIntakeViewModel(
            mainViewModel: mainViewModel
        )
        let goalsViewModel = GoalsViewModel(
            mainViewModel: mainViewModel,
            macrosIntakeViewModel: macrosIntakeViewModel,
            personalIntakeViewModel: personalIntakeViewModel,
            customIntakeViewModel: customIntakeViewModel
        )
        
        return NavigationStack {
            GoalsView(goalsViewModel: goalsViewModel)
        }
    }
}

#Preview {
    PreviewGoalsView.goalsView
}
