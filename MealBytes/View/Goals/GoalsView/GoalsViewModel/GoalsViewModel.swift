//
//  GoalsViewModel.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

final class GoalsViewModel: ObservableObject {
    enum NavigationDestination {
        case customRdiView
        case rdiView
        case none
    }

    @Published var navigationDestination: NavigationDestination = .none
    
    let customRdiViewModel: CustomRdiViewModel = CustomRdiViewModel()
    let rdiViewModel: RdiViewModel = RdiViewModel()
}
