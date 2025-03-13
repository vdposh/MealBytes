//
//  FoodView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct FoodView: View {
    @StateObject private var viewModel: FoodViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var isBookmarkFilled = false
    
    init(food: Food) {
        _viewModel = StateObject(wrappedValue: FoodViewModel(food: food))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    if !viewModel.isLoading {
                        servingSizeSection
                        nutrientActionSection
                        nutrientDetailSection
                    }
                }
                .listSectionSpacing(.compact)
                .scrollDismissesKeyboard(.never)
                
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .navigationBarTitle("Add to Diary", displayMode: .inline)
            .confirmationDialog(
                "Select Serving",
                isPresented: $viewModel.showActionSheet,
                titleVisibility: .visible
            ) {
                if let servings = viewModel.foodDetail?.servings.serving {
                    servingButtons(servings: servings)
                }
            }
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
    
    private var servingSizeSection: some View {
        Section {
            Text(viewModel.food.searchFoodName)
                .font(.headline)
                .listRowSeparator(.hidden)
                .padding(.top, 10)
            
            VStack(spacing: 15) {
                TextFieldView(title: "Size",
                              text: $viewModel.amount)
                .focused($isTextFieldFocused)
                .disabled(viewModel.isError)
                ButtonView(
                    title: "Serving",
                    description: viewModel.servingDescription,
                    showActionSheet: $viewModel.showActionSheet
                ) {
                    viewModel.showActionSheet.toggle()
                }
                .disabled(viewModel.isError)
            }
            .padding(.bottom, 10)
        }
    }
    
    private var nutrientActionSection: some View {
        Section {
            VStack {
                HStack {
                    ForEach(viewModel.compactNutrientDetails) { nutrient in
                        CompactNutrientDetailRow(nutrient: nutrient)
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
                            .background(viewModel.isAddButtonEnabled() ?
                                .customGreen : Color.customGreen.opacity(0.9))
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(12)
                    }
                    .disabled(!viewModel.isAddButtonEnabled() ||
                              viewModel.isError)
                    .buttonStyle(.plain)
                    
                    BookmarkButtonView(
                        action: {
                            isBookmarkFilled.toggle()
                        },
                        isFilled: isBookmarkFilled,
                        cornerRadius: 12,
                        lineWidth: 1.65
                    )
                }
                .padding(.bottom, 10)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
    }
    
    private var nutrientDetailSection: some View {
        Section {
            Text("Detailed Information")
                .font(.headline)
                .listRowSeparator(.hidden)
                .padding(.top, 10)
            
            ForEach(viewModel.nutrientDetails) { nutrient in
                NutrientDetailRow(nutrient: nutrient)
            }
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
            searchFoodId: "794",
            searchFoodName: "Whole Milk",
            searchFoodDescription: ""
        )
    )
}
