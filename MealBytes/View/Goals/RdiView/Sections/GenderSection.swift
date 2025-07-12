//
//  GenderSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/06/2025.
//

import SwiftUI

struct GenderSection: View {
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section {
            Picker("Gender", selection: $rdiViewModel.selectedGender) {
                if rdiViewModel.selectedGender == .notSelected {
                    Text("Not Selected").tag(Gender.notSelected)
                }
                ForEach(Gender.allCases.filter { $0 != .notSelected },
                        id: \.self) { gender in
                    Text(gender.rawValue).tag(gender)
                }
            }
            .pickerStyle(.menu)
            .accentColor(rdiViewModel.selectedGender.accentColor)
        } header: {
            Text("Set Gender")
        } footer: {
            Text("Specify gender to ensure RDI calculations.")
        }
    }
}

enum Gender: String, CaseIterable {
    case notSelected = "Not selected"
    case male = "Male"
    case female = "Female"
    
    var accentColor: Color {
        switch self {
        case .notSelected:
            return .customRed
        case .male, .female:
            return .customGreen
        }
    }
}

#Preview {
    let mainViewModel = MainViewModel()
    let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)

    return NavigationStack {
        RdiView(rdiViewModel: rdiViewModel)
    }
}
