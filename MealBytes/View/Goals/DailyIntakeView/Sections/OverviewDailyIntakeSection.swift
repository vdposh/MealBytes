//
//  OverviewDailyIntakeSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct OverviewDailyIntakeSection: View {
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        SectionStyleContainer(
            mainContent: {
                EmptyView()
            },
            title: "Set daily intake by entering calories directly or calculate it based on macronutrient distribution.",
            useUppercasedTitle: false
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 40)
    }
}

#Preview {
    let mainViewModel = MainViewModel()
    let dailyIntakeViewModel = DailyIntakeViewModel(
        mainViewModel: mainViewModel
    )
    
    return NavigationStack {
        DailyIntakeView(dailyIntakeViewModel: dailyIntakeViewModel)
    }
}
