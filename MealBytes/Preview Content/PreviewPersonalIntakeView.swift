//
//  PreviewPersonalIntakeView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/09/2025.
//

import SwiftUI

struct PreviewPersonalIntakeView {
    static var personalIntakeView: some View {
        let mainViewModel = MainViewModel()
        let personalIntakeViewModel = PersonalIntakeViewModel(
            mainViewModel: mainViewModel
        )
        
        return NavigationStack {
            PersonalIntakeView(personalIntakeViewModel: personalIntakeViewModel)
        }
    }
}

#Preview {
    PreviewPersonalIntakeView.personalIntakeView
}
