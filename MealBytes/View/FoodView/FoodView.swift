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
    
    var onAddFoodItem: (MealItem) -> Void
    
    init(food: Food, searchViewModel: SearchViewModel, onAddFoodItem: @escaping (MealItem) -> Void) {
        _viewModel = StateObject(wrappedValue: FoodViewModel(
            food: food, searchViewModel: searchViewModel))
        self.onAddFoodItem = onAddFoodItem
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
    }
    
    private var servingSizeSection: some View {
        Section {
            Text(viewModel.food.searchFoodName)
                .font(.headline)
                .listRowSeparator(.hidden)
                .padding(.top, 10)
            
            VStack(spacing: 15) {
                ServingTextFieldView(title: "Size",
                                     text: $viewModel.amount)
                .focused($isTextFieldFocused)
                .disabled(viewModel.isError)
                ServingButtonView(
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
                    ActionButtonView(
                        title: "Remove",
                        action: {
                            // Remove from Diary
                        },
                        backgroundColor: .customRed,
                        isEnabled: !viewModel.isError
                    )
                    
                    ActionButtonView(
                        title: "Add",
                        action: {
                            let servingDetail = viewModel.nutrientDetails.first(where: { $0.type == .servingSize })
                            let servingSize = servingDetail?.value ?? 0.0
                            let servingUnit = servingDetail?.serving.metricServingUnit ?? "N/A"
                            
                            let newItem = MealItem(
                                foodName: viewModel.food.searchFoodName,
                                portionSize: servingSize,
                                portionUnit: servingUnit,
                                calories: viewModel.nutrientDetails.first(where: { $0.type == .calories })?.value ?? 0.0,
                                fats: viewModel.nutrientDetails.first(where: { $0.type == .fat })?.value ?? 0.0,
                                proteins: viewModel.nutrientDetails.first(where: { $0.type == .protein })?.value ?? 0.0,
                                carbohydrates: viewModel.nutrientDetails.first(where: { $0.type == .carbohydrates })?.value ?? 0.0,
                                rsk: "N/A"
                            )
                            onAddFoodItem(newItem)
                        },
                        backgroundColor: .customGreen,
                        isEnabled: viewModel.isAddButtonEnabled() &&
                        !viewModel.isError
                    )
                    
                    BookmarkButtonView(
                        action: {
                            viewModel.toggleBookmark()
                        },
                        isFilled: viewModel.isBookmarkFilled,
                        isEnabled: !viewModel.isError
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
            searchFoodId: 794,
            searchFoodName: "Whole Milk",
            searchFoodDescription: ""
        ),
        searchViewModel: SearchViewModel(networkManager: NetworkManager()),
        onAddFoodItem: { _ in }
    )
}
