//
//  GoalsViewModel.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI
import Combine

final class GoalsViewModel: ObservableObject {
    @Published var calories: String = ""
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
    @Published var protein: String = ""
    @Published var isUsingPercentage: Bool = true
    private var isInitialized = false
    
    private let formatter: Formatter
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(formatter: Formatter = Formatter()) {
        self.formatter = formatter
        calories = "2000"
        fat = "30"
        carbohydrate = "50"
        protein = "20"
        isInitialized = true
        setupBindings()
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        Publishers.CombineLatest3($fat, $carbohydrate, $protein)
            .sink { [weak self] fat, carb, protein in
                self?.calculateCalories(fat: fat,
                                        carbohydrate: carb,
                                        protein: protein)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Calculations
    private func calculateCalories(fat: String,
                                   carbohydrate: String,
                                   protein: String) {
        guard isInitialized && !isUsingPercentage else {
            if calories.isEmpty || calories == "0" {
                calories = "2000"
            }
            return
        }
        let fatValue = Double(fat) ?? 0
        let carbValue = Double(carbohydrate) ?? 0
        let protValue = Double(protein) ?? 0
        let totalCalories = (fatValue * 9) + (carbValue * 4) + (protValue * 4)
        calories = formatter.formattedValue(totalCalories, unit: .empty)
    }
    
    // MARK: - Actions
    func togglePercentageMode() {
        guard let currentCalories = Double(calories), currentCalories > 0 else {
            showAlert(message: "Invalid calorie input")
            return
        }

        if isUsingPercentage {
            let fatP = Double(fat) ?? 0
            let carbP = Double(carbohydrate) ?? 0
            let protP = Double(protein) ?? 0
            let totalP = fatP + carbP + protP

            if totalP != 100 {
                showAlert(message: "Macronutrient percentages must sum up to 100%")
                return
            }

            fat = formatter.roundedValue(currentCalories * fatP / 100 / 9)
            carbohydrate = formatter.roundedValue(currentCalories * carbP / 100 / 4)
            protein = formatter.roundedValue(currentCalories * protP / 100 / 4)
        } else {
            let fatG = Double(fat) ?? 0
            let carbG = Double(carbohydrate) ?? 0
            let protG = Double(protein) ?? 0
            var fatP = max(floor((fatG * 9) / currentCalories * 100), 1)
            var carbP = max(floor((carbG * 4) / currentCalories * 100), 1)
            var protP = max(floor((protG * 4) / currentCalories * 100), 1)
            let totalP = fatP + carbP + protP

            if totalP > 100 {
                let excess = totalP - 100
                if protP >= fatP && protP >= carbP {
                    protP -= excess
                } else if carbP >= fatP {
                    carbP -= excess
                } else {
                    fatP -= excess
                }
            }

            if totalP < 100 {
                let deficit = 100 - totalP
                if protP >= fatP && protP >= carbP {
                    protP += deficit
                } else if carbP >= fatP {
                    carbP += deficit
                } else {
                    fatP += deficit
                }
            }

            fat = formatter.roundedValue(fatP)
            carbohydrate = formatter.roundedValue(carbP)
            protein = formatter.roundedValue(protP)
        }

        calories = formatter.roundedValue(currentCalories)
        isUsingPercentage.toggle()
    }

    func showAlert(message: String) {
        print(message)
    }

    // MARK: - UI Helpers
    func titleColor(for value: String) -> Color {
        switch value.isEmpty {
        case true: .customRed
        case false: .primary
        }
    }
    
    var caloriesTextColor: Color {
        switch isCaloriesTextFieldActive {
        case true: .secondary
        case false: .primary
        }
    }
    
    // MARK: - Unit Helpers
    func unitSymbol(inverted: Bool = false) -> String {
        switch (isUsingPercentage, inverted) {
        case (true, false): "%"
        case (true, true): "g"
        case (false, false): "g"
        case (false, true): "%"
        }
    }
    
    var toggleButtonText: String {
        switch isUsingPercentage {
        case true: "Use gramms"
        case false: "Use %"
        }
    }
    
    var isCaloriesTextFieldActive: Bool {
        switch isUsingPercentage {
        case true: false
        case false: true
        }
    }
}

#Preview {
    NavigationStack {
        GoalsView(viewModel: GoalsViewModel())
    }
    .accentColor(.customGreen)
}
