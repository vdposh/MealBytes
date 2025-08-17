//
//  PreviewContentView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 15/07/2025.
//

import SwiftUI

struct PreviewContentView {
    static var contentView: some View {
        ContentView(
            loginViewModel: PreviewFactory.loginViewModel,
            mainViewModel: PreviewFactory.mainViewModel,
            goalsViewModel: PreviewFactory.goalsViewModel,
            profileViewModel: PreviewFactory.profileViewModel
        )
        .environmentObject(PreviewFactory.themeManager)
    }
}
