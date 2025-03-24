//
//  CalorieMetricsSection.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI

struct CalorieMetricsSection: View {
    var isCaloriesFocused: FocusState<Bool>.Binding
    @ObservedObject var viewModel: CustomRdiViewModel
    
    var body: some View {
        Section {
            VStack {
                Text("Required Calorie Metrics")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 5)
                
                HStack(alignment: .bottom) {
                    ServingTextFieldView(
                        text: $viewModel.calories,
                        title: "Calories",
                        titleColor: viewModel.caloriesTextColor,
                        textColor: viewModel.caloriesTextColor
                    )
                    .focused(isCaloriesFocused)
                    .disabled(viewModel.isCaloriesTextFieldActive)
                    .padding(.trailing, 5)
                    
                    Text("kcal")
                        .font(.callout)
                        .foregroundColor(viewModel.caloriesTextColor)
                }
                .padding(.top, 5)
            }
            .padding(.bottom, 5)
        }
    }
}

#Preview {
    CustomRdiView(viewModel: CustomRdiViewModel(
        firestoreManager: FirestoreManager())
    )
    .accentColor(.customGreen)
}
