//
//  GoalsViewModel.swift
//  MealBytes
//
//  Created by Porshe on 05/04/2025.
//

import SwiftUI

final class GoalsViewModel: ObservableObject {
    @Published var isDataLoaded: Bool = false
    
    private let rdiViewModel = RdiViewModel()
    private let customRdiViewModel = CustomRdiViewModel()
    
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
}
