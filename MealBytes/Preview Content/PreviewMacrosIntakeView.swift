//
//  PreviewMacrosIntakeView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/09/2025.
//

import SwiftUI

struct PreviewMacrosIntakeView {
    static var macrosIntakeView: some View {
        let mainViewModel = MainViewModel()
        let macrosIntakeViewModel = MacrosIntakeViewModel(
            mainViewModel: mainViewModel
        )
        
        return NavigationStack {
            MacrosIntakeView(macrosIntakeViewModel: macrosIntakeViewModel)
        }
    }
}

#Preview {
    PreviewMacrosIntakeView.macrosIntakeView
}
