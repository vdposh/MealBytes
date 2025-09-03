//
//  FoodView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct FoodView: View {
    @FocusState private var amountFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    private let navigationTitle: String
    private let showAddButton: Bool
    private let showSaveRemoveButton: Bool
    private let showMealTypeButton: Bool
    
    @StateObject private var foodViewModel: FoodViewModel
    
    init(
        navigationTitle: String,
        food: Food,
        searchViewModel: SearchViewModelProtocol,
        mainViewModel: MainViewModelProtocol,
        mealType: MealType,
        amount: String,
        measurementDescription: String,
        showAddButton: Bool,
        showSaveRemoveButton: Bool,
        showMealTypeButton: Bool,
        originalCreatedAt: Date = Date(),
        originalMealItemId: UUID? = nil
    ) {
        self.navigationTitle = navigationTitle
        self.showAddButton = showAddButton
        self.showSaveRemoveButton = showSaveRemoveButton
        self.showMealTypeButton = showMealTypeButton
        _foodViewModel = StateObject(wrappedValue: FoodViewModel(
            food: food,
            mealType: mealType,
            searchViewModel: searchViewModel,
            mainViewModel: mainViewModel,
            initialAmount: amount,
            initialMeasurementDescription: measurementDescription,
            showSaveRemoveButton: showSaveRemoveButton,
            originalCreatedAt: originalCreatedAt,
            originalMealItemId: originalMealItemId
        ))
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            switch foodViewModel.viewState {
            case .loading:
                Color(.secondarySystemGroupedBackground)
                    .ignoresSafeArea()
                LoadingView()
                
            case .error(let error):
                Color(.secondarySystemGroupedBackground)
                    .ignoresSafeArea()
                contentUnavailableView(
                    for: error,
                    mealType: foodViewModel.mealType
                ) {
                    Task {
                        foodViewModel.appError = nil
                        await foodViewModel.fetchFoodDetails()
                    }
                }
                
            case .loaded:
                ScrollView {
                    servingSizeSection
                    nutrientActionSection
                    nutrientDetailSection
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarTitle(navigationTitle, displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                DoneButtonView {
                    amountFocused = false
                    foodViewModel.normalizeAmount()
                }
            }
        }
        .task {
            await foodViewModel.fetchFoodDetails()
        }
    }
    
    private var servingSizeSection: some View {
        VStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(foodViewModel.food.searchFoodName)
                    .font(.headline)
                
                ServingTextFieldView(
                    text: $foodViewModel.amount,
                    title: "Size",
                    placeholder: "Enter serving size",
                    titleColor: foodViewModel.titleColor(
                        for: foodViewModel.amount
                    )
                )
                .focused($amountFocused)
                .onChange(of: amountFocused) {
                    foodViewModel.handleFocusChange(
                        from: !amountFocused,
                        to: amountFocused
                    )
                }
                
                ServingButtonView(
                    showActionSheet: $foodViewModel.showServingDialog,
                    title: "Serving",
                    description: foodViewModel.servingDescription
                ) {
                    foodViewModel.showServingDialog.toggle()
                    amountFocused = false
                    foodViewModel.normalizeAmount()
                }
                .confirmationDialog(
                    "Select a Serving",
                    isPresented: $foodViewModel.showServingDialog,
                    titleVisibility: .visible
                ) {
                    if let servings = foodViewModel
                        .foodDetail?.servings.serving {
                        ForEach(servings, id: \.self) { serving in
                            Button(
                                foodViewModel.servingDescription(
                                    for: serving
                                )
                            ) {
                                foodViewModel.updateServing(serving)
                            }
                        }
                    }
                }
                
                if showMealTypeButton {
                    ServingButtonView(
                        showActionSheet: $foodViewModel.showMealTypeDialog,
                        title: "Meal Type",
                        description: foodViewModel.mealType.rawValue
                    ) {
                        foodViewModel.showMealTypeDialog.toggle()
                        amountFocused = false
                        foodViewModel.normalizeAmount()
                    }
                    .confirmationDialog(
                        "Select a Meal Type",
                        isPresented: $foodViewModel.showMealTypeDialog,
                        titleVisibility: .visible
                    ) {
                        ForEach(MealType.allCases, id: \.self) { meal in
                            Button(meal.rawValue) {
                                foodViewModel.mealType = meal
                            }
                        }
                    }
                }
            }
            .padding(20)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.top, 36)
    }
    
    private var nutrientActionSection: some View {
        VStack {
            HStack {
                switch showAddButton {
                case true:
                    ActionButtonView(
                        title: "Add",
                        action: {
                            Task {
                                await foodViewModel.addMealItemFoodView(
                                    in: foodViewModel.mealType,
                                    for: foodViewModel.mainViewModel.date
                                )
                                dismiss()
                            }
                        },
                        isEnabled: foodViewModel.canAddFood
                    )
                    
                    BookmarkButtonView(
                        action: {
                            Task {
                                await foodViewModel.toggleBookmarkFoodView()
                            }
                        },
                        isFilled: foodViewModel.isBookmarkFilled,
                        width: 55,
                        height: 30
                    )
                case false:
                    ActionButtonView(
                        title: "Remove",
                        action: {
                            foodViewModel.deleteMealItemFoodView()
                            dismiss()
                        },
                        color: .customRed
                    )
                    
                    ActionButtonView(
                        title: "Save",
                        action: {
                            Task {
                                await foodViewModel.updateMealItemFoodView(
                                    for: foodViewModel.mainViewModel.date
                                )
                                dismiss()
                            }
                        },
                        isEnabled: foodViewModel.canAddFood
                    )
                }
            }
            
            HStack {
                ForEach(
                    Array(foodViewModel.compactNutrientDetails.enumerated()),
                    id: \.element.id
                ) { index, nutrient in
                    CompactNutrientDetailRow(nutrient: nutrient)
                    
                    if index < foodViewModel.compactNutrientDetails.count - 1 {
                        Rectangle()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(width: 1, height: 50)
                    }
                }
            }
            .padding(.vertical, 12)
        }
        .padding(.top, 12)
        .padding(.horizontal, 16)
    }
    
    private var nutrientDetailSection: some View {
        NutrientDetailSection(
            title: "Detailed Information",
            nutrientDetails: foodViewModel.nutrientDetails
        )
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    NavigationStack {
        FoodView(
            navigationTitle: "Add to Diary",
            food: Food(
                searchFoodId: 3092,
                searchFoodName: "Egg",
                searchFoodDescription: "1 cup"
            ),
            searchViewModel: SearchViewModel(mainViewModel: MainViewModel()),
            mainViewModel: MainViewModel(),
            mealType: .breakfast,
            amount: "1",
            measurementDescription: "Grams",
            showAddButton: false,
            showSaveRemoveButton: true,
            showMealTypeButton: true,
            originalMealItemId: UUID()
        )
    }
}
