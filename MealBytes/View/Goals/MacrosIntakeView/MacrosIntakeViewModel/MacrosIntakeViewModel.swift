//
//  MacrosIntakeViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI
import Combine

protocol MacrosIntakeViewModelProtocol {
    var macrosIntakeText: String { get }
    
    func loadMacrosIntakeView() async
    func saveMacrosIntakeView() async
    func conditionallyClearMacrosIntake()
    func clearMacrosIntake()
}

final class MacrosIntakeViewModel: ObservableObject {
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
        
        setupBindingsMacrosIntakeView()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Load MacrosIntake Data
    func loadMacrosIntakeView() async {
        do {
            let macrosIntakeData = try await firestore
                .loadMacrosIntakeFirestore()
            
            await MainActor.run {
                calories = macrosIntakeData.calories
                fat = macrosIntakeData.fat
                carbohydrate = macrosIntakeData.carbohydrate
                protein = macrosIntakeData.protein
                didLoadNonEmptyIntake = !macrosIntakeData.calories.isEmpty
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    func conditionallyClearMacrosIntake() {
        if !didSaveSuccessfully && !didLoadNonEmptyIntake {
            clearMacrosIntake()
        }
        
        didSaveSuccessfully = false
        didLoadNonEmptyIntake = false
    }
    
    func clearMacrosIntake() {
        calories = ""
        fat = ""
        carbohydrate = ""
        protein = ""
    }
    
    // MARK: - Save MacrosIntake Data
    func saveMacrosIntakeView() async {
        let trimmedCalories = calories.trimmedLeadingZeros
        let macrosIntakeData = MacrosIntake(
            calories: trimmedCalories,
            fat: fat.trimmedLeadingZeros,
            carbohydrate: carbohydrate.trimmedLeadingZeros,
            protein: protein.trimmedLeadingZeros
        )
        
        do {
            try await firestore.saveMacrosIntakeFirestore(macrosIntakeData)
            
            await MainActor.run {
                mainViewModel.updateIntake(to: trimmedCalories)
                mainViewModel
                    .updateMacros(
                        fat: fat.trimmedLeadingZeros,
                        carbohydrate: carbohydrate.trimmedLeadingZeros,
                        protein: protein.trimmedLeadingZeros
                    )
                didSaveSuccessfully = true
            }
            
            await mainViewModel.saveCurrentIntakeMainView(
                source: "macrosIntakeView"
            )
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Calculation
    private func setupBindingsMacrosIntakeView() {
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
        let hasAnyValue = !fat.isEmpty ||
        !carbohydrate.isEmpty ||
        !protein.isEmpty
        
        guard hasAnyValue else { return false }
        
        if !fat.isEmpty && !fat.isValidNumericInput() {
            return false
        }
        if !carbohydrate.isEmpty && !carbohydrate.isValidNumericInput() {
            return false
        }
        if !protein.isEmpty && !protein.isValidNumericInput() {
            return false
        }
        
        return true
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
    
    var macrosIntakeText: String {
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

extension MacrosIntakeViewModel: MacrosIntakeViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewMacrosIntakeView.macrosIntakeView
}
