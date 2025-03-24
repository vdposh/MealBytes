//
//  CustomRdiViewModel.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI
import Combine

final class CustomRdiViewModel: ObservableObject {
    @Published var calories: String = ""
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
    @Published var protein: String = ""
    @Published var alertMessage: String = ""
    @Published var errorMessage: AppError?
    @Published var isUsingPercentage: Bool = true
    @Published var isShowingAlert: Bool = false
    @Published var isLoading: Bool = true
    private var isInitialized = false
    
    private let formatter: Formatter
    private let firestoreManager: FirestoreManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(formatter: Formatter = Formatter(),
         firestoreManager: FirestoreManagerProtocol) {
        self.formatter = formatter
        self.firestoreManager = firestoreManager
        calories = ""
        fat = "30"
        carbohydrate = "50"
        protein = "20"
        isInitialized = true
        setupBindings()
    }
    
    // MARK: - Load CustomGoals Data
    func loadCustomRdiView() async {
        do {
            let customGoalsData = try await firestoreManager
                .loadCustomRdiFirebase()
            await MainActor.run {
                calories = customGoalsData.calories
                fat = customGoalsData.fat
                carbohydrate = customGoalsData.carbohydrate
                protein = customGoalsData.protein
                isUsingPercentage = customGoalsData.isUsingPercentage
            }
        } catch {
            await MainActor.run {
                errorMessage = error as? AppError ?? .network
            }
        }
    }
    
    // MARK: - Save Texfields info
    func saveCustomRdiView() async {
        let customGoalsData = CustomRdiData(
            calories: calories,
            fat: fat,
            carbohydrate: carbohydrate,
            protein: protein,
            isUsingPercentage: isUsingPercentage
        )
        do {
            try await firestoreManager.saveCustomRdiFirebase(customGoalsData)
        } catch {
            errorMessage = error as? AppError ?? .network
        }
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
    
    // MARK: - Calculate Action
    func togglePercentageMode() {
        if let errorMessage = validateInputs(includePercentageCheck: true) {
            showAlert(message: errorMessage)
            return
        }
        
        let currentCalories = Double(calories) ?? 0
        
        switch isUsingPercentage {
        case true:
            let fatP = Double(fat) ?? 0
            let carbP = Double(carbohydrate) ?? 0
            let protP = Double(protein) ?? 0
            
            fat = formatter.roundedValue(currentCalories * fatP / 100 / 9)
            carbohydrate = formatter.roundedValue(currentCalories * carbP / 100 / 4)
            protein = formatter.roundedValue(currentCalories * protP / 100 / 4)
            
        case false:
            let fatG = Double(fat) ?? 0
            let carbG = Double(carbohydrate) ?? 0
            let protG = Double(protein) ?? 0
            var fatP = max(floor((fatG * 9) / currentCalories * 100), 1)
            var carbP = max(floor((carbG * 4) / currentCalories * 100), 1)
            var protP = max(floor((protG * 4) / currentCalories * 100), 1)
            let totalP = fatP + carbP + protP
            
            if totalP > 100 {
                let excess = totalP - 100
                switch true {
                case protP >= fatP && protP >= carbP: protP -= excess
                case carbP >= fatP: carbP -= excess
                default: fatP -= excess
                }
            }
            
            if totalP < 100 {
                let deficit = 100 - totalP
                switch true {
                case protP >= fatP && protP >= carbP: protP += deficit
                case carbP >= fatP: carbP += deficit
                default: fatP += deficit
                }
            }
            
            fat = formatter.roundedValue(fatP)
            carbohydrate = formatter.roundedValue(carbP)
            protein = formatter.roundedValue(protP)
        }
        
        calories = formatter.roundedValue(currentCalories)
        isUsingPercentage.toggle()
    }
    
    func validateInputs(includePercentageCheck: Bool = false) -> String? {
        var errorMessages: [String] = []
        let inputs: [(String, String)] = [
            (calories, "Invalid calorie input"),
            (fat, "Enter Fat"),
            (carbohydrate, "Enter Carbohydrate"),
            (protein, "Enter Protein")
        ]
        
        if includePercentageCheck && isUsingPercentage {
            let fatP = Double(fat) ?? 0
            let carbP = Double(carbohydrate) ?? 0
            let protP = Double(protein) ?? 0
            let totalP = fatP + carbP + protP
            
            if totalP != 100 {
                return "Macronutrient percentages must sum up to 100%"
            }
        }
        
        for (value, errorMessage) in inputs {
            switch true {
            case value.isEmpty,
                Double(value) == nil,
                Double(value) == 0:
                errorMessages.append(errorMessage)
            default:
                break
            }
        }
        
        switch errorMessages.isEmpty {
        case true:
            return nil
        case false:
            return errorMessages.joined(separator: "\n")
        }
    }
    
    func showAlert(message: String) {
        alertMessage = message
        isShowingAlert = true
    }
    
    // MARK: - For Text
    func oppositeValue(for value: String, factor: Double) -> String {
        guard
            let currCal = Double(calories),
            let numVal = Double(value),
            currCal > 0
        else { return "0" }
        
        switch isUsingPercentage {
        case true: // % -> Gramms
            let grams = currCal * numVal / 100 / factor
            return max(formatter.roundedValue(grams), "1")
            
        case false: // Gramms -> %
            let perc = (numVal * factor) / currCal * 100
            let roundedPerc = max(floor(perc), 1)
            
            let fatPerc = (Double(fat) ?? 0) * 9 / currCal * 100
            let carbPerc = (Double(carbohydrate) ?? 0) * 4 / currCal * 100
            let protPerc = (Double(protein) ?? 0) * 4 / currCal * 100
            let totalPerc = fatPerc + carbPerc + protPerc
            
            if totalPerc > 100 {
                let excess = totalPerc - 100
                if roundedPerc >= excess {
                    return formatter.roundedValue(roundedPerc - excess)
                }
            }
            
            if totalPerc < 100 {
                let deficit = 100 - totalPerc
                return formatter.roundedValue(roundedPerc + deficit)
            }
            
            return formatter.roundedValue(roundedPerc)
        }
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
        case false: "Use percents"
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
    CustomRdiView(customRdiViewModel: CustomRdiViewModel(
        firestoreManager: FirestoreManager())
    )
    .accentColor(.customGreen)
}
