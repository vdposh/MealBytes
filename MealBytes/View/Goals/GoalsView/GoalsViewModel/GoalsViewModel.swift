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
    
    init(
        customRdiViewModel: CustomRdiViewModel = CustomRdiViewModel(
            firestoreManager: FirestoreManager()),
        rdiViewModel: RdiViewModel = RdiViewModel(
            mainViewModel: MainViewModel())
    ) {
        self.customRdiViewModel = customRdiViewModel
        self.rdiViewModel = rdiViewModel
    }
}
