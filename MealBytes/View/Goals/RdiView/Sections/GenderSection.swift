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
            .pickerStyle(.navigationLink)
        } header: {
            Text("Set Gender")
        } footer: {
            Text("Specify gender to ensure RDI calculations.")
        }
    }
}

#Preview {
    NavigationStack {
        RdiView()
    }
}
