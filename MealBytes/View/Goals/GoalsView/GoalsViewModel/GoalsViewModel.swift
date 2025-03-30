//
//  GoalsViewModel.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

final class GoalsViewModel: ObservableObject {
    @Published var navigationDestination: NavigationDestination = .none
    
    let customRdiView = CustomRdiView()
    let rdiView = RdiView()
    
    // MARK: - Navigation
    enum NavigationDestination {
        case customRdiView
        case rdiView
        case none
    }
}
