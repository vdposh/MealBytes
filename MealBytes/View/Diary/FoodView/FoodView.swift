//
//  FoodView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct FoodView: View {
    @State private var mealType: MealType
    @FocusState private var amountFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    private let isEditingMealItem: Bool
    
    @StateObject private var foodViewModel: FoodViewModel
    
    init(
        mealType: MealType,
        food: Food,
        searchViewModel: SearchViewModelProtocol,
        mainViewModel: MainViewModelProtocol,
        amount: String,
        measurementDescription: String,
        isEditingMealItem: Bool,
        originalCreatedAt: Date = Date(),
        originalMealItemId: UUID? = nil
    ) {
        self._mealType = State(initialValue: mealType)
        self.isEditingMealItem = isEditingMealItem
        
        _foodViewModel = StateObject(
            wrappedValue: FoodViewModel(
                food: food,
                mealType: mealType,
                searchViewModel: searchViewModel,
                mainViewModel: mainViewModel,
                initialAmount: amount,
                initialMeasurementDescription: measurementDescription,
                isEditingMealItem: isEditingMealItem,
                originalCreatedAt: originalCreatedAt,
                originalMealItemId: originalMealItemId
            )
        )
    }
    
    var body: some View {
        foodViewContentBody
            .navigationTitle(foodViewModel.navigationTitleText)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                foodViewToolbar
            }
            .safeAreaInset(edge: .bottom) {
                if amountFocused {
                    KeyboardToolbarView(
                        done: {
                            amountFocused = false
                            foodViewModel.normalizeAmount()
                        }
                    )
                }
            }
            .background {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            }
            .onChange(of: mealType) {
                foodViewModel.mealType = mealType
            }
            .onChange(of: amountFocused) {
                foodViewModel.handleAmountFocusChange(
                    from: !amountFocused,
                    to: amountFocused
                )
            }
            .task {
                await foodViewModel.loadFoodData()
            }
    }
    
    @ViewBuilder
    private var foodViewContentBody: some View {
        switch foodViewModel.viewState {
        case .loading:
            LoadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .error(let error):
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
            Form {
                titleSection
                servingSizeSection
                nutritionFactsSection
            }
            .listSectionSpacing(20)
        }
    }
    
    private var titleSection: some View {
        Section {
            if let serving = foodViewModel.selectedServing {
                FoodItemView(
                    foodName: foodViewModel.food.searchFoodName,
                    formattedText: foodViewModel
                        .formattedMealText(
                            for: serving,
                            amount: foodViewModel.amount
                        ),
                    calories: serving.calories,
                    fat: serving.fat,
                    carbs: serving.carbohydrate,
                    protein: serving.protein
                )
            }
        }
    }
    
    @ViewBuilder
    private var servingSizeSection: some View {
        Section {
            ServingTextFieldView(
                text: $foodViewModel.amount,
                placeholder: "Enter amount",
                useLabel: true
            )
            .focused($amountFocused)
            
            if let selected = foodViewModel.selectedServing,
               let servings = foodViewModel.foodDetail?.servings.serving {
                Label {
                    Picker(
                        "Portion",
                        selection: $foodViewModel.selectedServing
                    ) {
                        ForEach(servings, id: \.self) { serving in
                            Text(
                                foodViewModel
                                    .servingDescription(
                                        for: serving,
                                        showUnit: true
                                    )
                            )
                            .tag(serving as Serving?)
                        }
                    }
                } icon: {
                    Image(systemName: "text.justify")
                        .foregroundStyle(.customGray)
                        .symbolColorRenderingMode(.gradient)
                }
                .onChange(of: selected) {
                    foodViewModel.updateServing(selected)
                    amountFocused = false
                    foodViewModel.normalizeAmount()
                }
            }
        }
        
        Section {
            Label {
                Picker("Meal type", selection: $mealType) {
                    ForEach(MealType.allCases, id: \.self) { meal in
                        Text(meal.rawValue)
                            .tag(meal)
                    }
                }
            } icon: {
                Image(systemName: "fork.knife")
                    .foregroundStyle(.customGray)
                    .symbolColorRenderingMode(.gradient)
            }
            .onChange(of: mealType) {
                amountFocused = false
                foodViewModel.normalizeAmount()
            }
        }
    }
    
    private var nutritionFactsSection: some View {
        Section {
            NutrientValueSection(
                nutrients: foodViewModel.nutrientValues,
                isFoodView: true
            )
        } header: {
            Text("Nutrition Facts")
        }
    }
    
    @ToolbarContentBuilder
    private var foodViewToolbar: some ToolbarContent {
        if isEditingMealItem {
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    Task {
                        await foodViewModel
                            .updateMealItemFoodView(
                                for: foodViewModel.mainViewModel.date
                            )
                        
                        dismiss()
                    }
                }
                .disabled(!foodViewModel.canAddFood)
            }
        } else {
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    Task {
                        await foodViewModel.addMealItemFoodView(
                            in: foodViewModel.mealType,
                            for: foodViewModel.mainViewModel.date
                        )
                        
                        dismiss()
                    }
                } label: {
                    Text("Add")
                        .fontWeight(.medium)
                }
                .disabled(!foodViewModel.canAddFood)
            }
        }
        
        ToolbarItem(placement: .bottomBar) {
            Button {
                Task {
                    await foodViewModel.toggleBookmarkFoodView()
                }
                
                if !foodViewModel.isBookmarkFilled {
                    amountFocused = false
                    foodViewModel.normalizeAmount()
                }
            } label: {
                Image(
                    systemName: foodViewModel.isBookmarkFilled
                    ? "bookmark.slash"
                    : "bookmark"
                )
            }
        }
        
        ToolbarSpacer(.flexible, placement: .bottomBar)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
