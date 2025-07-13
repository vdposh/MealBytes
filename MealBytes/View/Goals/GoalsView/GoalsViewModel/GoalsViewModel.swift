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
    
    var currentRdiSource: RdiSourceType {
        RdiSourceType(rawValue: mainViewModel.rdiSource) ?? .rdiView
    }
    
    func isActive(_ source: RdiSourceType) -> Bool {
        currentRdiSource == source
    }
    
    func color(for source: RdiSourceType) -> Color {
        isActive(source) ? .customGreen : .secondary
    }
    
    func weight(for source: RdiSourceType) -> Font.Weight {
        isActive(source) ? .medium : .regular
    }
    
    func icon(for source: RdiSourceType) -> String {
        isActive(source) ? "person.fill" : "person"
    }
}

enum RdiSourceType: String {
    case rdiView
    case customRdiView
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
