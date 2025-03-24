//
//  GoalsViewModel.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

final class GoalsViewModel: ObservableObject {
    let customRdiViewModel: CustomRdiViewModel
    let rdiViewModel: RdiViewModel
    let firestoreManager: FirestoreManager
    
    init() {
        self.firestoreManager = FirestoreManager()
        self.customRdiViewModel = CustomRdiViewModel(
            firestoreManager: firestoreManager)
        self.rdiViewModel = RdiViewModel()
    }
}
