//
//  FoodViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI
import Combine
import FirebaseCore

final class FoodViewModel: ObservableObject {
    @Published var selectedServing: Serving?
    @Published var amount: String = ""
    @Published var originalAmount: String = ""
    @Published var appError: AppError?
    @Published var unit: MeasurementUnit = .grams
    @Published var isLoading: Bool = true
    @Published var isError: Bool = false
    @Published var isBookmarkFilled: Bool = false
    @Published var showServingDialog: Bool = false
    @Published var showMealTypeDialog: Bool = false
    @Published var foodDetail: FoodDetail? {
        didSet {
            self.selectedServing = nil
        }
    }
    
    private let formatter = Formatter()
    private let originalMealType: MealType
    private let originalCreatedAt: Date
    private let originalMealItemId: UUID
    private let initialMeasurementDescription: String
    private let showSaveRemoveButton: Bool
    private var didChangeMealType: Bool {
        mealType != originalMealType
    }
    
    let food: Food
    var mealType: MealType
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let searchViewModel: SearchViewModelProtocol
    let mainViewModel: MainViewModelProtocol
    
    init(food: Food,
         mealType: MealType,
         searchViewModel: SearchViewModelProtocol,
         mainViewModel: MainViewModelProtocol,
         initialAmount: String = "",
         initialMeasurementDescription: String = "",
         showSaveRemoveButton: Bool = false,
         originalCreatedAt: Date = Date(),
         originalMealItemId: UUID? = nil) {
        let roundedAmount = Formatter().formattedValue(
            Double(initialAmount),
            unit: .empty,
            alwaysRoundUp: false
        )
        
        self.food = food
        self.mealType = mealType
        self.originalMealType = mealType
        self.searchViewModel = searchViewModel
        self.mainViewModel = mainViewModel
        self.isBookmarkFilled = searchViewModel.isBookmarkedSearchView(food)
        self.amount = roundedAmount
        self.initialMeasurementDescription = initialMeasurementDescription
        self.showSaveRemoveButton = showSaveRemoveButton
        self.originalCreatedAt = originalCreatedAt
        self.originalMealItemId = originalMealItemId ?? UUID()
    }
    
    // MARK: - Fetch Food Details
    @MainActor
    func fetchFoodDetails() async {
        isLoading = true
        
        do {
            let fetchedFoodDetail = try await networkManager
                .fetchFoodDetails(foodId: food.searchFoodId)
            self.foodDetail = fetchedFoodDetail
            
            switch fetchedFoodDetail.servings.serving.first(where: {
                $0.measurementDescription == initialMeasurementDescription
            }) {
            case let matchingServing?:
                self.selectedServing = matchingServing
            default:
                self.selectedServing = fetchedFoodDetail.servings.serving.first
            }
            
            if !showSaveRemoveButton {
                setAmount(for: selectedServing)
            }
        } catch {
            switch error {
            case let appError as AppError:
                self.appError = appError
            default:
                self.appError = .network
            }
            isError = true
        }
        isLoading = false
    }
    
    // MARK: - Add a food item
    func addMealItemFoodView(in section: MealType, for date: Date) {
        let nutrients = nutrientDetails.reduce(into: [NutrientType: Double]()) {
            result, detail in
            result[detail.type] = detail.value
        }
        let newItem = MealItem(
            foodId: food.searchFoodId,
            foodName: food.searchFoodName,
            portionUnit: nutrientDetails.first(where: {
                $0.type == .servingSize })?.serving.metricServingUnit ?? "",
            nutrients: nutrients,
            measurementDescription:
                selectedServing?.measurementDescription ?? "",
            amount: Double(amount.sanitizedForDouble) ?? 0,
            date: date, mealType: mealType
        )
        mainViewModel.addMealItemMainView(newItem, to: section, for: date)
        
        Task {
            do {
                try await firestore.addMealItemFirestore(newItem)
            } catch {
                await MainActor.run {
                    appError = .disconnected
                }
            }
        }
    }
    
    // MARK: - Resave food
    func updateMealItemFoodView(for date: Date) async {
        guard let selectedServing else { return }
        
        let createdAt = didChangeMealType ? Date() : originalCreatedAt
        
        let updatedMealItem = MealItem(
            id: originalMealItemId,
            foodId: food.searchFoodId,
            foodName: food.searchFoodName,
            portionUnit: selectedServing.metricServingUnit,
            nutrients: nutrientDetails.reduce(into: [NutrientType: Double]()) {
                result, detail in result[detail.type] = detail.value
            },
            measurementDescription: selectedServing.measurementDescription,
            amount: Double(amount.sanitizedForDouble) ?? 0,
            date: date,
            mealType: mealType,
            createdAt: createdAt
        )
        
        Task {
            do {
                if originalMealType == mealType {
                    await MainActor.run {
                        mainViewModel.updateMealItemMainView(
                            updatedMealItem,
                            for: mealType,
                            on: date
                        )
                    }
                    try await firestore.updateMealItemFirestore(updatedMealItem)
                } else {
                    await MainActor.run {
                        mainViewModel.deleteMealItemMainView(
                            with: originalMealItemId,
                            for: originalMealType
                        )
                    }
                    
                    if mainViewModel.filteredMealItems(for: originalMealType,
                                                       on: date).isEmpty {
                        await MainActor.run {
                            mainViewModel.collapseSection(
                                for: originalMealType,
                                to: false
                            )
                        }
                    }
                    
                    await MainActor.run {
                        mainViewModel.addMealItemMainView(
                            updatedMealItem,
                            to: mealType,
                            for: date
                        )
                        mainViewModel.collapseSection(
                            for: originalMealType,
                            to: true
                        )
                    }
                    
                    try await firestore.updateMealItemFirestore(updatedMealItem)
                }
            } catch {
                await MainActor.run {
                    appError = .disconnected
                }
            }
        }
    }
    
    // MARK: - Delete food
    func deleteMealItemFoodView() async {
        mainViewModel.deleteMealItemMainView(with: originalMealItemId,
                                             for: originalMealType)
    }
    
    // MARK: - Bookmark Management
    func toggleBookmarkFoodView() {
        isBookmarkFilled.toggle()
        searchViewModel.toggleBookmarkSearchView(for: food)
    }
    
    // MARK: - Serving Selection and Amount Setting
    func updateServing(_ serving: Serving) {
        self.selectedServing = serving
        setAmount(for: serving)
        self.unit = serving.measurementUnit
    }
    
    private func setAmount(for serving: Serving?) {
        guard let serving else {
            self.amount = ""
            return
        }
        
        switch serving.isMetricMeasurement {
        case true:
            self.amount = "100"
        case false:
            self.amount = "1"
        }
    }
    
    // MARK: - Serving Description
    func servingDescription(for serving: Serving) -> String {
        var description = serving.measurementDescription
        let metricAmountFormatted = formatter.formattedValue(
            serving.metricServingAmount,
            unit: .empty
        )
        let metricUnit = serving.metricServingUnit
        
        if serving.isMetricMeasurement {
            return description
        }
        
        if description.hasPrefix("serving"),
           let range = description.range(of: #"serving\s*\([^)]+\)"#,
                                         options: .regularExpression) {
            description.replaceSubrange(range, with: "serving")
        }
        
        return "\(description) (\(metricAmountFormatted)\(metricUnit))"
    }
    
    var servingDescription: String {
        guard let selectedServing else {
            return "Select a Serving"
        }
        return servingDescription(for: selectedServing)
    }
    
    // MARK: - Button States
    var canAddFood: Bool {
        amount.isValidNumericInput()
    }
    
    // MARK: - Nutrient Calculation
    private func calculateSelectedAmountValue() -> Double {
        guard let selectedServing, canAddFood else { return 0 }
        
        let amountValue = Double(amount.sanitizedForDouble) ?? 0
        return calculateBaseAmountValue(amountValue, serving: selectedServing)
    }
    
    private func calculateBaseAmountValue(_ amount: Double,
                                          serving: Serving) -> Double {
        if amount.isZero {
            return 0
        }
        
        switch serving.isMetricMeasurement {
        case true:
            return amount * 0.01
        case false:
            return amount
        }
    }
    
    var compactNutrientDetails: [CompactNutrientDetail] {
        guard let selectedServing else { return [] }
        return CompactNutrientDetailProvider()
            .getCompactNutrientDetails(from: selectedServing)
            .map { detail in
                CompactNutrientDetail(
                    type: detail.type,
                    value: detail.value * calculateSelectedAmountValue(),
                    serving: detail.serving
                )
            }
    }
    
    var nutrientDetails: [NutrientDetail] {
        guard let selectedServing else { return [] }
        return NutrientDetailProvider()
            .getNutrientDetails(from: selectedServing)
            .map { detail in
                NutrientDetail(
                    type: detail.type,
                    value: detail.value * calculateSelectedAmountValue(),
                    serving: selectedServing,
                    isSubValue: detail.isSubValue
                )
            }
    }
    
    // MARK: - Text
    func titleColor(for value: String) -> Color {
        value.isValidNumericInput() ? .secondary : .customRed
    }
    
    //MARK: - Keyboard
    func normalizeAmount() {
        amount = amount.trimmedLeadingZeros
    }
    
    // MARK: - Focus
    func handleFocusChange(from oldValue: Bool, to newValue: Bool) {
        if newValue {
            originalAmount = amount
            amount = ""
        } else {
            if let newAmount = Double(amount.sanitizedForDouble),
               newAmount > 0 {
                originalAmount = amount
            } else {
                amount = originalAmount
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
    PreviewContentView.contentView
}

#Preview {
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
