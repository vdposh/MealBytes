//
//  FoodView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Combine

struct FoodView: View {
    @StateObject private var viewModel: FoodViewModel
    
    init(food: Food) {
        _viewModel = StateObject(wrappedValue: FoodViewModel(food: food))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    if viewModel.foodDetail != nil {
                        Section {
                            Text("\(viewModel.food.food_name)")
                                .font(.headline)
                                .listRowSeparator(.hidden)
                                .padding(.top, 10)
                            
                            VStack(spacing: 15) {
                                CustomTextFieldView(title: "Size",
                                                    text: $viewModel.amount)
                                CustomButtonView(
                                    title: "Serving",
                                    description: viewModel.servingDescription,
                                    showActionSheet: $viewModel.showActionSheet
                                ) {
                                    viewModel.showActionSheet.toggle()
                                }
                                .confirmationDialog(
                                    "Select Serving",
                                    isPresented: $viewModel.showActionSheet,
                                    titleVisibility: .visible
                                ) {
                                    if let servings = viewModel
                                        .foodDetail?.servings.serving {
                                        servingButtons(servings: servings)
                                    }
                                }
                            }
                            .padding(.bottom, 10)
                        }
                    }
                    
                    if let selectedServing = viewModel.selectedServing {
                        let amountValue = viewModel.calculateAmountValue()
                        
                        Section {
                            VStack {
                                HStack {
                                    viewModel.nutrientBlockView(
                                        title: "Kcal",
                                        value: selectedServing.calories,
                                        unit: "",
                                        amountValue: amountValue
                                    )
                                    viewModel.nutrientBlockView(
                                        title: "Fat",
                                        value: selectedServing.fat,
                                        unit: "g",
                                        amountValue: amountValue
                                    )
                                    viewModel.nutrientBlockView(
                                        title: "Protein",
                                        value: selectedServing.protein,
                                        unit: "g",
                                        amountValue: amountValue
                                    )
                                    viewModel.nutrientBlockView(
                                        title: "Carb",
                                        value: selectedServing.carbohydrate,
                                        unit: "g",
                                        amountValue: amountValue
                                    )
                                }
                                .padding(.vertical, 10)
                                
                                HStack {
                                    Button(action: {
                                        // Remove from Diary
                                    }) {
                                        Text("Remove")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(.customRed)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .cornerRadius(12)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Button(action: {
                                        // Add to Diary
                                    }) {
                                        Text("Add to Diary")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(viewModel
                                                .isAddToDiaryButtonEnabled() ?
                                                .customGreen : Color
                                                .customGreen.opacity(0.9))
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .cornerRadius(12)
                                    }
                                    .disabled(!viewModel
                                        .isAddToDiaryButtonEnabled())
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.bottom, 10)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                        }
                        
                        Section {
                            Text("Detailed Information")
                                .font(.headline)
                                .listRowSeparator(.hidden)
                                .padding(.top, 10)
                            viewModel.nutrientDetailRow(
                                title: "Calories",
                                value: selectedServing.calories,
                                unit: "kcal",
                                amountValue: amountValue
                            )
                            viewModel.nutrientDetailRow(
                                title: "Serving size",
                                value: selectedServing.metricServingAmount,
                                unit: selectedServing.metricServingUnit,
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            viewModel.nutrientDetailRow(
                                title: "Fat",
                                value: selectedServing.fat,
                                unit: "g",
                                amountValue: amountValue
                            )
                            viewModel.nutrientDetailRow(
                                title: "Saturated Fat",
                                value: selectedServing.saturatedFat,
                                unit: "g",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            viewModel.nutrientDetailRow(
                                title: "Monounsaturated Fat",
                                value: selectedServing.monounsaturatedFat,
                                unit: "g",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            viewModel.nutrientDetailRow(
                                title: "Polyunsaturated Fat",
                                value: selectedServing.polyunsaturatedFat,
                                unit: "g",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            viewModel.nutrientDetailRow(
                                title: "Carbohydrates",
                                value: selectedServing.carbohydrate,
                                unit: "g",
                                amountValue: amountValue
                            )
                            viewModel.nutrientDetailRow(
                                title: "Sugar",
                                value: selectedServing.sugar,
                                unit: "g",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            viewModel.nutrientDetailRow(
                                title: "Fiber",
                                value: selectedServing.fiber,
                                unit: "g",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            viewModel.nutrientDetailRow(
                                title: "Protein",
                                value: selectedServing.protein,
                                unit: "g",
                                amountValue: amountValue
                            )
                            viewModel.nutrientDetailRow(
                                title: "Potassium",
                                value: selectedServing.potassium,
                                unit: "mg",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            viewModel.nutrientDetailRow(
                                title: "Sodium",
                                value: selectedServing.sodium,
                                unit: "mg",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            viewModel.nutrientDetailRow(
                                title: "Cholesterol",
                                value: selectedServing.cholesterol,
                                unit: "mg",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                        }
                    }
                }
                .listSectionSpacing(.compact)
                
                if viewModel.foodDetail == nil {
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(tint: .customGreen))
                            .scaleEffect(1.5)
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Add to Diary", displayMode: .inline)
        }
        .onAppear {
            viewModel.fetchFoodDetails()
        }
        .alert(item: $viewModel.errorMessage) { message in
            Alert(
                title: Text("Error"),
                message: Text(message.value),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func servingButtons(servings: [Serving]) -> some View {
        ForEach(servings, id: \.self) { serving in
            Button(viewModel.servingDescription(for: serving)) {
                viewModel.selectedServing = serving
                viewModel.setAmount(for: serving)
                viewModel.unit = (serving.measurementDescription == "g" ||
                                  serving.measurementDescription == "ml") ?
                    .grams : .servings
            }
        }
    }
}

enum MeasurementUnit: String, CaseIterable, Identifiable {
    case servings = "Servings"
    case grams = "Grams"
    
    var id: String { self.rawValue }
}

#Preview {
    FoodView(
        food: Food(
            food_id: "39715",
            food_name: "Oats, 123",
            food_description: ""
        )
    )
}
