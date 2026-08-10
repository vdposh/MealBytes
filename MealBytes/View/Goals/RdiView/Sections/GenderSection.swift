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
        NavigationLink {
            GenderSelectionView(selectedGender: $rdiViewModel.selectedGender)
        } label: {
            LabeledContent {
                Text(rdiViewModel.selectedGender.rawValue)
            } label: {
                Text("Gender")
            }
        }
    }
}

struct GenderSelectionView: View {
    @Binding var selectedGender: Gender
    
    var body: some View {
        Form {
            ForEach(
                Gender.allCases.filter { $0 != .notSelected
                },
                id: \.self) { gender in
                    Button {
                        selectedGender = gender
                    } label: {
                        Text(gender.rawValue)
                            .foregroundStyle(Color.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 32)
                            .overlay(alignment: .trailing) {
                                if selectedGender == gender {
                                    Image(systemName: "checkmark")
                                        .font(.headline)
                                }
                            }
                    }
                }
        }
        .navigationTitle("Gender")
    }
}

enum Gender: String, CaseIterable {
    case notSelected = ""
    case male = "Male"
    case female = "Female"
}

#Preview {
    PreviewRdiView.rdiView
}
