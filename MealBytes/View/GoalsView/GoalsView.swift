//
//  GoalsView.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

struct GoalsView: View {
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var viewModel: GoalsViewModel
    
    init(viewModel: GoalsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
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
                            textColor: viewModel.isCaloriesTextFieldActive ?
                                .secondary : .primary
                        )
                        .disabled(viewModel.isCaloriesTextFieldActive)
                        .padding(.trailing, 5)
                        Text("kcal")
                            .font(.callout)
                            .foregroundColor(viewModel.caloriesTextColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 5)
                    Text("MealBytes calculates your Recommended Daily Intake (RDI) to provide you with a daily calorie target tailored to help you achieve your desired weight.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 10)
                    
                    HStack {
                        Button(action: {
                            print("Calculate RDI pressed")
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
            Section {
                VStack {
                    Text("Required Macronutrient Metrics")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 5)
                    HStack(alignment: .bottom) {
                        ServingTextFieldView(
                            text: $viewModel.fat,
                            title: "Fat",
                            titleColor: viewModel.titleColor(for: viewModel.fat)
                        )
                        .padding(.top, 5)
                        Text(viewModel.isUsingPercentage ? "%" : "g")
                            .font(.callout)
                            .foregroundColor(.primary)
                            .frame(width: 20, alignment: .trailing)
                    }
                    HStack(alignment: .bottom) {
                        ServingTextFieldView(
                            text: $viewModel.carbohydrate,
                            title: "Carbohydrate",
                            titleColor: viewModel.titleColor(for: viewModel.carbohydrate)
                        )
                        Text(viewModel.isUsingPercentage ? "%" : "g")
                            .font(.callout)
                            .foregroundColor(.primary)
                            .frame(width: 20, alignment: .trailing)
                    }
                    HStack(alignment: .bottom) {
                        ServingTextFieldView(
                            text: $viewModel.protein,
                            title: "Protein",
                            titleColor: viewModel.titleColor(for: viewModel.protein)
                        )
                        Text(viewModel.isUsingPercentage ? "%" : "g")
                            .font(.callout)
                            .foregroundColor(.primary)
                            .frame(width: 20, alignment: .trailing)
                    }
                    .padding(.bottom, 10)
                    HStack {
                        Button(action: { viewModel.togglePercentageMode() }) {
                            Text(viewModel.isUsingPercentage ?
                                 "Use gramms" : "Use %")
                            .font(.headline)
                            .foregroundColor(.customGreen)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, 5)
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
        .listSectionSpacing(15)
        .scrollDismissesKeyboard(.never)
        .navigationBarTitle("Your Goal", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Text("Enter value")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button("Done") { isTextFieldFocused = false }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GoalsView(viewModel: GoalsViewModel())
    }
    .accentColor(.customGreen)
}
