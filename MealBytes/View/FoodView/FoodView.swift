//
//  FoodView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Combine

struct FoodView: View {
    let food: Food
    @StateObject private var viewModel = FoodViewModel()
    @State private var unit: MeasurementUnit = .grams
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    if viewModel.foodDetail != nil {
                        Section(header: Text("Serving Size")) {
                            HStack(spacing: 15) {
                                VStack(spacing: 40) {
                                    Image(systemName: "plusminus")
                                        .foregroundColor(.gray)
                                    Image(systemName: "list.bullet")
                                        .foregroundColor(.gray)
                                }
                                
                                VStack(spacing: 15) {
                                    TextField("Enter amount",
                                              text: $viewModel.amount)
                                    .keyboardType(.decimalPad)
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray,
                                                    lineWidth: 0.5)
                                    )
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    
                                    Button(action: {
                                        viewModel.showActionSheet.toggle()
                                    }) {
                                        HStack {
                                            Text(viewModel.servingDescription)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.green)
                                        }
                                        .padding(10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray,
                                                        lineWidth: 0.5)
                                        )
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                    }
                                    .buttonStyle(PlainButtonStyle())
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
                            }
                            .padding(.vertical, 10)
                        }
                    }
                    
                    if let selectedServing = viewModel.selectedServing {
                        let amountValue = viewModel.calculateAmountValue()
                        
                        Section {
                            VStack {
                                HStack(alignment: .center, spacing: 12) {
                                    nutrientBlockView(
                                        title: "Kcal",
                                        value: selectedServing.calories,
                                        unit: "",
                                        amountValue: amountValue
                                    )
                                    nutrientBlockView(
                                        title: "Fat",
                                        value: selectedServing.fat,
                                        unit: "g",
                                        amountValue: amountValue
                                    )
                                    nutrientBlockView(
                                        title: "Protein",
                                        value: selectedServing.protein,
                                        unit: "g",
                                        amountValue: amountValue
                                    )
                                    nutrientBlockView(
                                        title: "Carb",
                                        value: selectedServing.carbohydrate,
                                        unit: "g",
                                        amountValue: amountValue
                                    )
                                }
                                Divider()
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 10)
                                
                                HStack(alignment: .center, spacing: 12) {
                                    Button(action: {
                                        // Remove from Diary
                                    }) {
                                        Text("Remove")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(.red)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .cornerRadius(15)
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
                                                .green : Color
                                                .green.opacity(0.9))
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .cornerRadius(15)
                                    }
                                    .disabled(!viewModel
                                        .isAddToDiaryButtonEnabled())
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .listRowBackground(Color.clear)
                            .padding(.top, 10)
                        }
                        
                        Section(header: Text("Detailed Information")) {
                            nutrientDetailRow(
                                title: "Calories",
                                value: selectedServing.calories,
                                unit: "kcal",
                                amountValue: amountValue
                            )
                            nutrientDetailRow(
                                title: "Serving size",
                                value: selectedServing.metric_serving_amount,
                                unit: selectedServing.metric_serving_unit ?? "",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            nutrientDetailRow(
                                title: "Fat",
                                value: selectedServing.fat,
                                unit: "g",
                                amountValue: amountValue
                            )
                            nutrientDetailRow(
                                title: "Saturated Fat",
                                value: selectedServing.saturated_fat,
                                unit: "g",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            nutrientDetailRow(
                                title: "Monounsaturated Fat",
                                value: selectedServing.monounsaturated_fat,
                                unit: "g",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            nutrientDetailRow(
                                title: "Polyunsaturated Fat",
                                value: selectedServing.polyunsaturated_fat,
                                unit: "g",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            nutrientDetailRow(
                                title: "Carbohydrates",
                                value: selectedServing.carbohydrate,
                                unit: "g",
                                amountValue: amountValue
                            )
                            nutrientDetailRow(
                                title: "Sugar",
                                value: selectedServing.sugar,
                                unit: "g",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            nutrientDetailRow(
                                title: "Fiber",
                                value: selectedServing.fiber,
                                unit: "g",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            nutrientDetailRow(
                                title: "Protein",
                                value: selectedServing.protein,
                                unit: "g",
                                amountValue: amountValue
                            )
                            nutrientDetailRow(
                                title: "Potassium",
                                value: selectedServing.potassium,
                                unit: "mg",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            nutrientDetailRow(
                                title: "Sodium",
                                value: selectedServing.sodium,
                                unit: "mg",
                                amountValue: amountValue,
                                isSubValue: true
                            )
                            nutrientDetailRow(
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
                                CircularProgressViewStyle(tint: .green))
                            .scaleEffect(1.5)
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(food.food_name, displayMode: .inline)
        }
        .onAppear {
            viewModel.fetchFoodDetails(foodID: food.food_id)
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
                unit = (serving.measurement_description == "g" ||
                        serving.measurement_description == "ml") ?
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
            food_name: "Oats",
            food_description: ""
        )
    )
}
