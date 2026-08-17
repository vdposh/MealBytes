//
//  DailyIntakeViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI
import Combine

protocol DailyIntakeViewModelProtocol {
    var dailyIntakeText: String { get }
    
    func loadDailyIntakeView() async
    func saveDailyIntakeView() async
    func conditionallyClearDailyIntake()
    func clearDailyIntake()
}

final class DailyIntakeViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var calories: String = ""
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
    @Published var protein: String = ""
    @Published var didSaveSuccessfully: Bool = false
    @Published var didLoadNonEmptyIntake: Bool = false
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let mainViewModel: MainViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
        
        setupBindingsDailyIntakeView()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Load DailyIntake Data
    func loadDailyIntakeView() async {
        do {
            let dailyIntakeData = try await firestore
                .loadDailyIntakeFirestore()
            
            await MainActor.run {
                calories = dailyIntakeData.calories
                fat = dailyIntakeData.fat
                carbohydrate = dailyIntakeData.carbohydrate
                protein = dailyIntakeData.protein
                didLoadNonEmptyIntake = !dailyIntakeData.calories.isEmpty
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    func conditionallyClearDailyIntake() {
        if !didSaveSuccessfully && !didLoadNonEmptyIntake {
            clearDailyIntake()
        }
        
        didSaveSuccessfully = false
        didLoadNonEmptyIntake = false
    }
    
    func clearDailyIntake() {
        calories = ""
        fat = ""
        carbohydrate = ""
        protein = ""
    }
    
    // MARK: - Save DailyIntake Data
    func saveDailyIntakeView() async {
        let trimmedCalories = calories.trimmedLeadingZeros
        let dailyIntakeData = DailyIntake(
            calories: trimmedCalories,
            fat: fat.trimmedLeadingZeros,
            carbohydrate: carbohydrate.trimmedLeadingZeros,
            protein: protein.trimmedLeadingZeros
        )
        
        do {
            try await firestore.saveDailyIntakeFirestore(dailyIntakeData)
            
            await MainActor.run {
                mainViewModel.updateIntake(to: trimmedCalories)
                didSaveSuccessfully = true
            }
            
            await mainViewModel.saveCurrentIntakeMainView(
                source: "dailyIntakeView"
            )
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Calculation
    private func setupBindingsDailyIntakeView() {
        Publishers.CombineLatest3($fat, $carbohydrate, $protein)
            .sink { [weak self] fat, carb, protein in
                self?.calculateCalories(
                    fat: fat,
                    carbohydrate: carb,
                    protein: protein
                )
            }
            .store(in: &cancellables)
    }
    
    private func calculateCalories(
        fat: String,
        carbohydrate: String,
        protein: String
    ) {
        
        let fatValue = fat.doubleValue ?? 0
        let carbValue = carbohydrate.doubleValue ?? 0
        let protValue = protein.doubleValue ?? 0
        
        let allEmpty = fat.isEmpty && carbohydrate.isEmpty && protein.isEmpty
        let allZero = fatValue == 0 && carbValue == 0 && protValue == 0
        
        if allEmpty || allZero {
            calories = "0"
            return
        }
        
        let totalCalories = (fatValue * 9) + (carbValue * 4) + (protValue * 4)
        
        calories = totalCalories > 0
        ? totalCalories.asWhole()
        : "0"
    }
    
    var isValid: Bool {
        fat.isValidNumericInput() &&
        carbohydrate.isValidNumericInput() &&
        protein.isValidNumericInput()
    }
    
    // MARK: - Text
    func text(for calculatedIntake: String, useUnit: Bool = true) -> String {
        guard isValid else {
            return "Fill in the data"
        }
        
        guard let intakeValue = calculatedIntake.doubleValue,
              intakeValue > 0 else {
            return "Fill in the data"
        }
        
        let formattedValue = intakeValue.asWhole()
        
        guard useUnit else {
            return formattedValue
        }
        
        return intakeValue == 1
        ? "\(formattedValue) calorie"
        : "\(formattedValue) calories"
    }
    
    var dailyIntakeText: String {
        text(for: calories)
    }
    
    // MARK: - Keyboard
    func normalizeInputs() {
        calories = calories.trimmedLeadingZeros
        fat = fat.trimmedLeadingZeros
        carbohydrate = carbohydrate.trimmedLeadingZeros
        protein = protein.trimmedLeadingZeros
    }
    
    // MARK: - Focus
    func handleMacronutrientsFocusChange(
        focus: MacronutrientsFocus,
        didGainFocus: Bool
    ) {
        normalizeInputs()
        
        switch focus {
        case .fat:
            if didGainFocus {
            } else if fat.isValidNumericInput() {
                fat = fat.trimmedLeadingZeros
            }
            
        case .carbohydrate:
            if didGainFocus {
            } else if carbohydrate.isValidNumericInput() {
                carbohydrate = carbohydrate.trimmedLeadingZeros
            }
            
        case .protein:
            if didGainFocus {
            } else if protein.isValidNumericInput() {
                protein = protein.trimmedLeadingZeros
            }
        }
    }
}

extension DailyIntakeViewModel: DailyIntakeViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
