//
//  GenderView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 17.09.2026.
//

import SwiftUI

struct GenderView: View {
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
