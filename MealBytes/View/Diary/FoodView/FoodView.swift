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
            .navigationTitle(navigationTitleText)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                foodViewToolbar
            }
            .onChange(of: mealType) {
                foodViewModel.mealType = mealType
            }
            .onChange(of: amountFocused) {
                foodViewModel.handleFocusChange(
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
                .listSectionSpacing(15)
                .scrollIndicators(.hidden)
            }
        }
    }
    
    private var servingSizeSection: some View {
        Section {
            ServingTextFieldView(
                text: $foodViewModel.amount,
                placeholder: "Serving size",
                trailingUnit: foodViewModel.servingUnit,
                useLabel: true
            )
            .focused($amountFocused)
            
            if let selected = foodViewModel.selectedServing,
               let servings = foodViewModel.foodDetail?.servings.serving {
                PickerRowView(
                    title: foodViewModel
                        .servingDescription(for: selected),
                    iconName: "text.justify",
                    mealType: mealType,
                    useRendering: false
                ) {
                    ForEach(servings, id: \.self) { serving in
                        Button {
                            foodViewModel.updateServing(serving)
                            amountFocused = false
                            foodViewModel.normalizeAmount()
                        } label: {
                            Label {
                                Text(
                                    foodViewModel
                                        .servingDescription(
                                            for: serving,
                                            showUnit: true
                                        )
                                )
                            } icon: {
                                if serving == selected {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
            
            if isEditingMealItem {
                PickerRowView(
                    title: mealType.rawValue,
                    iconName: mealType.iconName,
                    mealType: mealType,
                    useRendering: true
                ) {
                    Picker("Meal Type", selection: $mealType) {
                        ForEach(MealType.allCases, id: \.self) { meal in
                            Label(meal.rawValue, systemImage: meal.iconName)
                                .tag(meal)
                        }
                    }
                }
                .onChange(of: mealType) {
                    amountFocused = false
                    foodViewModel.normalizeAmount()
                }
            }
        } header: {
            Text(foodViewModel.food.searchFoodName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.primary)
                .listRowInsets(
                    EdgeInsets(top: 20, leading: 16, bottom: 16, trailing: 16)
                )
        }
    }
    
    private var nutrientActionSection: some View {
        Section {
            if isEditingMealItem {
                HStack(spacing: 10) {
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
            } else {
                HStack(spacing: 15) {
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
                            
                            if !foodViewModel.isBookmarkFilled {
                                amountFocused = false
                                foodViewModel.normalizeAmount()
                            }
                        },
                        isFilled: foodViewModel.isBookmarkFilled
                    )
                }
            }
            
            HStack {
                ForEach(
                    Array(foodViewModel.compactNutrientDetails.enumerated()),
                    id: \.element.id
                ) { index, nutrient in
                    let intakePercentageText = foodViewModel.mainViewModel.canDisplayIntake()
                    ? foodViewModel.mainViewModel
                        .intakePercentage(for: nutrient.value)
                    : nil
                    
                    CompactNutrientValueRow(
                        nutrient: nutrient,
                        intakePercentage: nutrient.type == .calories
                        ? intakePercentageText
                        : nil
                    )
                    
                    if index < foodViewModel.compactNutrientDetails.count - 1 {
                        Rectangle()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(width: 1, height: 50)
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(.vertical, 8)
        .listRowInsets(
            EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        )
        .listSectionMargins(.horizontal, 0)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var detailedInformationSection: some View {
        NutrientValueSection(
            nutrients: foodViewModel.nutrientValues,
            isExpandable: nil,
            useServing: true,
            intakePercentage: foodViewModel.mainViewModel.canDisplayIntake()
            ? foodViewModel.mainViewModel.intakePercentage(
                for: foodViewModel.nutrientValues
                    .first(where: { $0.type == .calories })?.value
            )
            : nil
        )
    }
    
    private var navigationTitleText: String {
        isEditingMealItem
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
