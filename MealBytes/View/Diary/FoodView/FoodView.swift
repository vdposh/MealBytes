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
            .navigationSubtitle(foodViewModel.mainViewModel.formattedDate())
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
            }
        }
    }
    
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
            
            if isEditingMealItem {
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
                HStack(spacing: 10) {
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
                    let intakePercentageText = foodViewModel
                        .mainViewModel.canDisplayIntake()
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
        .listRowInsets(.vertical, 0)
        .listSectionMargins(.horizontal, 0)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var detailedInformationSection: some View {
        NutrientValueSection(
            nutrients: foodViewModel.nutrientValues,
            isExpandable: nil,
            intakePercentage: foodViewModel.mainViewModel.canDisplayIntake()
            ? foodViewModel.mainViewModel.intakePercentage(
                for: foodViewModel.nutrientValues
                    .first(where: { $0.type == .calories })?.value ?? 0
            )
            : nil
        )
    }
    
    private var navigationTitleText: String {
        isEditingMealItem
        ? "Edit in Diary"
        : "Add to \(foodViewModel.mealType.rawValue)"
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
