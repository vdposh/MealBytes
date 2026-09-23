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
        let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)
        let customIntakeViewModel = CustomIntakeViewModel(
            mainViewModel: mainViewModel
        )
        let goalsViewModel = GoalsViewModel(
            mainViewModel: mainViewModel,
            macrosIntakeViewModel: macrosIntakeViewModel,
            rdiViewModel: rdiViewModel,
            customIntakeViewModel: customIntakeViewModel
        )
        
        return GoalsView(goalsViewModel: goalsViewModel)
    }
}

#Preview {
    PreviewGoalsView.goalsView
}
