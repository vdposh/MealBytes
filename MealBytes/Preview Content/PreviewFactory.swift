//
//  PreviewFactory.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 15/07/2025.
//

import SwiftUI

struct PreviewFactory {
    static let loginViewModel = LoginViewModel()
    static let mainViewModel = MainViewModel()
    
    static let dailyIntakeViewModel:
    DailyIntakeViewModelProtocol = DailyIntakeViewModel(
        mainViewModel: mainViewModel
    )
    
    static let rdiViewModel:
    RdiViewModelProtocol = RdiViewModel(
        mainViewModel: mainViewModel
    )
    
    static let goalsViewModel = GoalsViewModel(
        mainViewModel: mainViewModel,
        dailyIntakeViewModel: dailyIntakeViewModel,
        rdiViewModel: rdiViewModel
    )
    
    static let profileViewModel = ProfileViewModel(
        loginViewModel: loginViewModel,
        mainViewModel: mainViewModel
    )
    
    static let themeManager = ThemeManager()
}
