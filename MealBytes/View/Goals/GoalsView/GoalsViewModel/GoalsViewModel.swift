//
//  GoalsViewModel.swift
//  MealBytes
//
//  Created by Porshe on 05/04/2025.
//

import SwiftUI

final class GoalsViewModel: ObservableObject {
    @Published var isDataLoaded: Bool = false
    
    private let rdiViewModel: RdiViewModel = RdiViewModel()
    private let customRdiViewModel: CustomRdiViewModel = CustomRdiViewModel()
    
    // MARK: - Load Data
    func loadProfileData() async {
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
        customRdiViewModel.isSaved
        ? "\(customRdiViewModel.calories) calories"
        : "Fill in the data"
    }
}
