//
//  CalorieMetricsSection.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI

struct CalorieMetricsSection: View {
    var isCaloriesFocused: FocusState<Bool>.Binding
    @ObservedObject var viewModel: GoalsViewModel
    
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
                
                HStack {
                    Button(action: {
                        // link RDI
                    }) {
                        Text("Calculate My RDI")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.customGreen)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom, 5)
                }
            }
        }
    }
}

#Preview {
    GoalsView(viewModel: GoalsViewModel(
        firestoreManager: FirestoreManager())
    )
    .accentColor(.customGreen)
}
