//
//  FoodView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct FoodView: View {
    @State private var mealType: MealType
    @FocusState private var amountFocused: Bool?
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
        originalMealItemId: UUID? = nil,
        originalDate: Date? = nil
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
                originalMealItemId: originalMealItemId,
                originalDate: originalDate
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
                foodViewSafeArea
            }
            .ignoresSafeArea(edges: amountFocused == true ? [] : .bottom)
            .background {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            }
            .onChange(of: amountFocused) {
                let isFocused = amountFocused == true
                foodViewModel.handleAmountFocusChange(
                    from: !isFocused,
                    to: isFocused
                )
            }
            .task {
                await foodViewModel.loadFoodData()
            }
    }
    
    // MARK: - Content
    @ViewBuilder
    private var foodViewContentBody: some View {
        switch foodViewModel.viewState {
        case .loading:
            ProgressView()
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
                foodItemSection
                servingSizeSection
                nutritionFactsSection
            }
            .environment(\.defaultMinListRowHeight, 46)
            .listSectionSpacing(20)
            .sheet(isPresented: $foodViewModel.showDatePicker) {
                DatePickerSheet(
                    selectedDate: $foodViewModel.selectedDate,
                    isPresented: $foodViewModel.showDatePicker
                )
            }
        }
    }
    
    // MARK: - Food Item
    private var foodItemSection: some View {
        Section {
            if let serving = foodViewModel.selectedServing {
                let nutrients = foodViewModel.nutrientValues
                let calories = nutrients.first(
                    where: { $0.type == .calories
                    })?.value ?? 0
                let fat = nutrients.first(
                    where: { $0.type == .fat
                    })?.value ?? 0
                let carbs = nutrients.first(
                    where: { $0.type == .carbohydrate
                    })?.value ?? 0
                let protein = nutrients.first(
                    where: { $0.type == .protein
                    })?.value ?? 0
                
                FoodItemView(
                    foodName: foodViewModel.food.searchFoodName,
                    formattedText: foodViewModel
                        .formattedMealText(
                            for: serving,
                            amount: foodViewModel.amount
                        ),
                    calories: calories,
                    fat: fat,
                    carbs: carbs,
                    protein: protein
                )
            }
        }
    }
    
    // MARK: - Serving
    @ViewBuilder
    private var servingSizeSection: some View {
        Section {
            DatePickerRow(
                selectedDate: $foodViewModel.selectedDate,
                isPresented: $foodViewModel.showDatePicker
            )
            
            Picker("Meal Type", selection: $mealType) {
                ForEach(MealType.allCases, id: \.self) { meal in
                    Text(meal.rawValue)
                        .tag(meal)
                }
            }
            .onChange(of: mealType) {
                foodViewModel.updateMealType(mealType)
                amountFocused = nil
                foodViewModel.normalizeAmount()
            }
        }
        
        Section {
            ServingTextFieldView(
                text: $foodViewModel.amount,
                focus: $amountFocused,
                focusCase: true
            )
            
            if let selected = foodViewModel.selectedServing,
               let servings = foodViewModel.foodDetail?.servings.serving {
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
                .onChange(of: selected) {
                    foodViewModel.updateServing(selected)
                    amountFocused = nil
                    foodViewModel.normalizeAmount()
                }
            }
        }
    }
    
    // MARK: - Nutrition Facts
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
    
    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var foodViewToolbar: some ToolbarContent {
        switch foodViewModel.viewMode {
        case .fromSearchView:
            if !foodViewModel.isLoading && foodViewModel.shouldShowToolbar {
                ToolbarItem {
                    Button(role: .confirm) {
                        Task {
                            await foodViewModel.addMealItemFoodView(
                                in: foodViewModel.mealType,
                                for: foodViewModel.selectedDate
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
            
        case .fromMainView:
            if !foodViewModel.isLoading && foodViewModel.shouldShowToolbar {
                ToolbarItem {
                    Button(role: .confirm) {
                        Task {
                            await foodViewModel.updateMealItemFoodView(
                                for: foodViewModel.selectedDate
                            )
                            
                            dismiss()
                        }
                    }
                    .disabled(!foodViewModel.canAddFood)
                }
            }
            
            if !foodViewModel.shouldShowToolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    } label: {
                        Text("Close")
                            .fontWeight(.medium)
                    }
                }
            }
        }
    }
    
    // MARK: - Safearea
    private var foodViewSafeArea: some View {
        HStack {
            if !foodViewModel.isLoading && foodViewModel.shouldShowToolbar {
                switch foodViewModel.viewMode {
                case .fromSearchView:
                    ToolbarButtonView(
                        icon: foodViewModel.isBookmarkFilled
                        ? "bookmark.slash"
                        : "bookmark",
                        action: {
                            Task {
                                await foodViewModel.toggleBookmarkFoodView()
                            }
                            amountFocused = nil
                            foodViewModel.normalizeAmount()
                        },
                        focused: amountFocused == true
                    )
                    
                case .fromMainView:
                    ToolbarButtonView(
                        icon: "trash",
                        action: {
                            foodViewModel.deleteMealItemFoodView()
                            dismiss()
                        },
                        focused: amountFocused == true
                    )
                }
            }
            
            ToolbarButtonView(
                action: {
                    amountFocused = nil
                    foodViewModel.normalizeAmount()
                },
                alignment: .center,
                focused: amountFocused == true
            )
            .opacity(amountFocused == true ? 1 : 0)
            .allowsHitTesting(amountFocused == true)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
