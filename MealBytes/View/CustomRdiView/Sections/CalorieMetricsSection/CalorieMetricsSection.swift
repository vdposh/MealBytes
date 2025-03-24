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
                
                Text("MealBytes calculates your Recommended Daily Intake (RDI) to provide you with a daily calorie target tailored to help you achieve your desired weight.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 10)
                
                Text("You can also calculate your Recommended Daily Intake (RDI) manually by entering calories and macronutrient values such as fats, carbohydrates and proteins.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 10)
                
                
                HStack {
                    RdiButtonView(
                        title: "Custom RDI",
                        backgroundColor: .customGreen,
                        action: {
                            // action
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                    
                    RdiButtonView(
                        title: "Calculate RDI",
                        backgroundColor: .customGreen,
                        action: {
                            // action
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom, 5)
                }
            }
        }
    }
}

#Preview {
    CustomRdiView(viewModel: CustomRdiViewModel(
        firestoreManager: FirestoreManager())
    )
    .accentColor(.customGreen)
}
