//
//  GoalsViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/04/2025.
//

import SwiftUI

final class GoalsViewModel: ObservableObject {
    @Published var isDataLoaded: Bool = false
    
    private let mainViewModel: MainViewModel
    let rdiViewModel: RdiViewModel
    let customRdiViewModel: CustomRdiViewModel
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        self.rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)
        self.customRdiViewModel = CustomRdiViewModel(
            mainViewModel: mainViewModel
        )
    }
    
    // MARK: - Load Data
    func loadGoalsData() async {
        async let rdiTask: () = rdiViewModel.loadRdiView()
        async let customRdiTask: () = customRdiViewModel.loadCustomRdiView()
        
        _ = await (rdiTask, customRdiTask)
        
        await MainActor.run {
            isDataLoaded = true
        }
    }
    
    // MARK: - Text
    func rdiText() -> String {
        rdiViewModel.text(for: rdiViewModel.calculatedRdi)
    }
    
    func customRdiText() -> String {
        customRdiViewModel.text(for: customRdiViewModel.calories)
    }
    
    var rdiStyle: (color: Color, weight: Font.Weight) {
        mainViewModel.rdiSource == "rdiView"
        ? (.customGreen, .medium)
        : (.secondary, .regular)
    }
    
    var customRdiStyle: (color: Color, weight: Font.Weight) {
        mainViewModel.rdiSource == "customRdiView"
        ? (.customGreen, .medium)
        : (.secondary, .regular)
    }
}

#Preview {
    let loginViewModel = LoginViewModel()
    let mainViewModel = MainViewModel()
    let goalsViewModel = GoalsViewModel(mainViewModel: mainViewModel)
    
    ContentView(
        loginViewModel: loginViewModel,
        mainViewModel: mainViewModel,
        goalsViewModel: goalsViewModel
    )
    .environmentObject(ThemeManager())
}
