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
        let dailyIntakeViewModel = DailyIntakeViewModel(
            mainViewModel: mainViewModel)
        let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)
        let goalsViewModel = GoalsViewModel(
            mainViewModel: mainViewModel,
            dailyIntakeViewModel: dailyIntakeViewModel,
            rdiViewModel: rdiViewModel
        )
        
        return GoalsView(goalsViewModel: goalsViewModel)
    }
}

#Preview {
    PreviewGoalsView.goalsView
}
