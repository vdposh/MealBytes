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
        VStack(alignment: .leading) {
            Text("SET GENDER")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
            
            HStack {
                Text("Gender")
                    .padding(.leading, 20)
                
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
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 10)
            }
            .padding(.vertical, 5)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            
            Text("Specify gender to ensure RDI calculations.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 25)
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
