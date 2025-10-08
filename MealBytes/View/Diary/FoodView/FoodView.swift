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
    
    private let showAddButton: Bool
    private let showSaveRemoveButton: Bool
    
    @StateObject private var foodViewModel: FoodViewModel
    
    init(
        food: Food,
        searchViewModel: SearchViewModelProtocol,
        mainViewModel: MainViewModelProtocol,
        mealType: MealType,
        amount: String,
        measurementDescription: String,
        showAddButton: Bool,
        showSaveRemoveButton: Bool,
        originalCreatedAt: Date = Date(),
        originalMealItemId: UUID? = nil
    ) {
        self.showAddButton = showAddButton
        self.showSaveRemoveButton = showSaveRemoveButton
        _foodViewModel = StateObject(
            wrappedValue: FoodViewModel(
                food: food,
                mealType: mealType,
                searchViewModel: searchViewModel,
                mainViewModel: mainViewModel,
                initialAmount: amount,
                initialMeasurementDescription: measurementDescription,
                showSaveRemoveButton: showSaveRemoveButton,
                originalCreatedAt: originalCreatedAt,
                originalMealItemId: originalMealItemId
            )
        )
    }
    
    var body: some View {
        foodViewContentBody
            .navigationTitle(navigationTitleText)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                foodViewToolbar
            }
            .task {
                await foodViewModel.fetchFoodDetails()
            }
    }
    
    @ViewBuilder
    private var foodViewContentBody: some View {
        ZStack {
            switch foodViewModel.viewState {
            case .loading:
                LoadingView()
                
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
                    servingSizeSection
                    nutrientActionSection
                    detailedInformationSection
                }
                .listSectionSpacing(16)
                .scrollIndicators(.hidden)
            }
        }
    }
    
    private var servingSizeSection: some View {
        Section {
            ServingTextFieldView(
                text: $foodViewModel.amount,
                placeholder: "Serving size"
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
                            foodViewModel.servingDescription(for: serving)
                        ) {
                            foodViewModel.updateServing(serving)
                        }
                    }
                }
            }
            
            if showSaveRemoveButton {
                ServingButtonView(
                    showActionSheet: $foodViewModel.showMealTypeDialog,
                    title: "MealType",
                    description: foodViewModel.mealType.rawValue
                ) {
                    foodViewModel.showMealTypeDialog.toggle()
                    amountFocused = false
                    foodViewModel.normalizeAmount()
                }
                .confirmationDialog(
                    "MealType",
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
        } header: {
            Text(foodViewModel.food.searchFoodName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.primary)
                .listRowInsets(
                    EdgeInsets(top: 34, leading: 16, bottom: 16, trailing: 16)
                )
        }
    }
    
    private var nutrientActionSection: some View {
        Section {
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
                        isFilled: foodViewModel.isBookmarkFilled
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
                                await foodViewModel
                                    .updateMealItemFoodView(
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
                    CompactNutrientValueRow(nutrient: nutrient)
                    
                    if index < foodViewModel.compactNutrientDetails.count - 1 {
                        Rectangle()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(width: 1, height: 50)
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var detailedInformationSection: some View {
        NutrientValueSection(
            nutrients: foodViewModel.nutrientValues,
            isExpandable: nil
        )
    }
    
    private var navigationTitleText: String {
        showSaveRemoveButton
        ? "Edit in Diary"
        : "Add to \(foodViewModel.mealType.rawValue)"
    }
    
    @ToolbarContentBuilder
    private var foodViewToolbar: some ToolbarContent {
        ToolbarItem(placement: .keyboard) {
            KeyboardToolbarView(
                done: {
                    amountFocused = false
                    foodViewModel.normalizeAmount()
                }
            )
            .padding(.trailing, 8)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
