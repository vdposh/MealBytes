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
    @FocusState private var isTextFieldFocused: Bool
    
    init(food: Food) {
        _viewModel = StateObject(wrappedValue: FoodViewModel(food: food))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    if !viewModel.isLoading {
                        Section {
                            Text(viewModel.food.searchFoodName)
                                .font(.headline)
                                .listRowSeparator(.hidden)
                                .padding(.top, 10)
                            
                            VStack(spacing: 15) {
                                CustomTextFieldView(title: "Size",
                                                    text: $viewModel.amount)
                                .focused($isTextFieldFocused)
                                .disabled(viewModel.isError)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Text("Enter serving size")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Button("Done") {
                                            isTextFieldFocused = false
                                        }
                                    }
                                }
                                CustomButtonView(
                                    title: "Serving",
                                    description: viewModel.servingDescription,
                                    showActionSheet: $viewModel.showActionSheet
                                ) {
                                    viewModel.showActionSheet.toggle()
                                }
                                .disabled(viewModel.isError)
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
                        
                        Section {
                            VStack {
                                HStack {
                                    ForEach(viewModel.nutrientBlocks,
                                            id: \.title) { nutrient in
                                        CompactNutrientDetailRow(
                                            title: nutrient.title,
                                            value: nutrient.value,
                                            unit: nutrient.unit
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
                                    .buttonStyle(.plain)
                                    .disabled(viewModel.isError)
                                    
                                    Button(action: {
                                        // Add to Diary
                                    }) {
                                        Text("Add to Diary")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(viewModel
                                                .isAddButtonEnabled() ?
                                                .customGreen : Color
                                                .customGreen.opacity(0.9))
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .cornerRadius(12)
                                    }
                                    .disabled(!viewModel
                                        .isAddButtonEnabled() ||
                                              viewModel.isError)
                                    .buttonStyle(.plain)
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
                            
                            ForEach(viewModel.nutrientDetails, id: \.title) { nutrient in
                                NutrientDetailRow(
                                    title: nutrient.title,
                                    value: nutrient.value,
                                    unit: nutrient.unit,
                                    isSubValue: nutrient.isSubValue
                                )
                            }
                        }
                    }
                }
                .listSectionSpacing(.compact)
                .scrollDismissesKeyboard(.never)
                
                if viewModel.isLoading {
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

#Preview {
    FoodView(
        food: Food(
            searchFoodId: "39715",
            searchFoodName: "Oats, 123",
            searchFoodDescription: ""
        )
    )
}
