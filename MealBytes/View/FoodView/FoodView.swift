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
                                let nutrients = NutrientDetailProvider
                                    .getCompactNutrientDetails(from: selectedServing)
                                
                                HStack {
                                    ForEach(nutrients, id: \.0) { nutrient in
                                        viewModel.nutrientBlockView(
                                            title: nutrient.0,
                                            value: nutrient.1,
                                            unit: nutrient.2,
                                            amountValue: amountValue
                                        )
                                    }
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
                            
                            let nutrientDetails = NutrientDetailProvider
                                .getNutrientDetails(from: selectedServing)
                            
                            ForEach(nutrientDetails, id:
                                        \.0.title) { nutrient in
                                viewModel.nutrientDetailRow(
                                    title: nutrient.0.title,
                                    value: nutrient.1,
                                    unit: nutrient.0.unit,
                                    amountValue: amountValue,
                                    isSubValue: nutrient.2
                                )
                            }
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
        .task {
            await viewModel.fetchFoodDetails()
        }
        .alert(item: $viewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.errorDescription),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func servingButtons(servings: [Serving]) -> some View {
        ForEach(servings, id: \.self) { serving in
            Button(viewModel.servingDescription(for: serving)) {
                viewModel.updateServing(serving)
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
