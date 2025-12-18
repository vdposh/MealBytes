//
//  PreviewDailyIntakeView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/09/2025.
//

import SwiftUI

struct PreviewDailyIntakeView {
    static var dailyIntakeView: some View {
        let mainViewModel = MainViewModel()
        let dailyIntakeViewModel = DailyIntakeViewModel(
            mainViewModel: mainViewModel
        )
        
        return NavigationStack {
            DailyIntakeView(dailyIntakeViewModel: dailyIntakeViewModel)
        }
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
