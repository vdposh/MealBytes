//
//  PreviewRdiView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/09/2025.
//

import SwiftUI

struct PreviewRdiView {
    static var rdiView: some View {
        let mainViewModel = MainViewModel()
        let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)
        
        return NavigationStack {
            RdiView(rdiViewModel: rdiViewModel)
        }
    }
}

#Preview {
    PreviewRdiView.rdiView
}
