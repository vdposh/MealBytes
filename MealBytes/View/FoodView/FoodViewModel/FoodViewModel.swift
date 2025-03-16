//
//  FoodViewModel.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Combine

final class FoodViewModel: ObservableObject {
    @Published var foodDetail: FoodDetail? {
        didSet {
            self.selectedServing = self.foodDetail?.servings.serving.first
            setAmount(for: self.selectedServing)
        }
    }
    @Published var selectedServing: Serving?
    @Published var amount: String = ""
    @Published var errorMessage: AppError?
    @Published var showActionSheet = false
    @Published var unit: MeasurementUnit = .grams
    @Published var isLoading = true
    @Published var isError = false
    @Published var isBookmarkFilled = false
    
    let food: Food
    
    private let networkManager: NetworkManagerProtocol
    private let searchViewModel: SearchViewModel
    
    init(food: Food,
         searchViewModel: SearchViewModel,
         networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.food = food
        self.networkManager = networkManager
        self.searchViewModel = searchViewModel
        self.isBookmarkFilled = searchViewModel.isBookmarked(food)
    }
    
    // MARK: - Fetch Food Details
    @MainActor
    func fetchFoodDetails() async {
        isLoading = true
        do {
            let fetchedFoodDetail = try await networkManager
                .fetchFoodDetails(foodId: food.searchFoodId)
            self.foodDetail = fetchedFoodDetail
        } catch {
            switch error {
            case let appError as AppError:
                self.errorMessage = appError
            default:
                self.errorMessage = .networkError
            }
            isError = true
        }
        isLoading = false
    }
    
    // MARK: - Bookmark Management
    func toggleBookmark() {
        isBookmarkFilled.toggle()
        searchViewModel.toggleBookmark(for: food)
    }
    
    // MARK: - Serving Selection and Amount Setting
    func updateServing(_ serving: Serving) {
        self.selectedServing = serving
        setAmount(for: serving)
        self.unit = serving.measurementUnit
    }
    
    func setAmount(for serving: Serving?) {
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
        let description = serving.measurementDescription
        let metricAmount = Int(serving.metricServingAmount)
        let metricUnit = serving.metricServingUnit
        
        switch serving.isMetricMeasurement {
        case true:
            return description
        case false where description.contains("serving (\(metricAmount)g"):
            return description
        default:
            return "\(description) (\(metricAmount)\(metricUnit))"
        }
    }
    
    var servingDescription: String {
        guard let selectedServing else {
            return "Select Serving"
        }
        return servingDescription(for: selectedServing)
    }
    
    // MARK: - Button States
    func isAddButtonEnabled() -> Bool {
        let amountValue = Double(amount.replacingOccurrences(of: ",",
                                                             with: ".")) ?? 0
        return amountValue > 0
    }
    
    // MARK: - Adds a food item to the specified meal section
    func addFoodItem(to mainViewModel: MainViewModel, in section: MealType) {
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
            servingDescription: servingDescription,
            amount: Double(amount.replacingOccurrences(of: ",",
                                                       with: ".")) ?? 0
        )
        
        mainViewModel.addFoodItem(newItem, to: section)
    }
    
    // MARK: - Nutrient Calculation
    func calculateSelectedAmountValue() -> Double {
        guard let selectedServing else { return 1 }
        let amountValue = Double(amount.replacingOccurrences(of: ",",
                                                             with: ".")) ?? 0
        return calculateBaseAmountValue(amountValue,
                                        serving: selectedServing)
    }
    
    func calculateBaseAmountValue(_ amount: Double,
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
}

enum MeasurementUnit: String, CaseIterable, Identifiable {
    case servings = "Servings"
    case grams = "Grams"
    
    var id: String { self.rawValue }
}

#Preview {
    FoodView(
        food: Food(
            searchFoodId: 794,
            searchFoodName: "Whole Milk",
            searchFoodDescription: ""
        ),
        searchViewModel: SearchViewModel(networkManager: NetworkManager()),
        mainViewModel: MainViewModel(),
        mealType: .breakfast,
        isFromSearchView: true
    )
}
