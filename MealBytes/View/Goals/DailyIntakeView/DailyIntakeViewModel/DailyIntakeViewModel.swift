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
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var didSaveSuccessfully: Bool = false
    @Published var didLoadNonEmptyIntake: Bool = false
    @Published var toggleOn: Bool = false {
        didSet {
            handleToggleChange()
        }
    }
    
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
            let hasAnyData = !dailyIntakeData.calories.isEmpty
            
            await MainActor.run {
                toggleOn = dailyIntakeData.macronutrientMetrics
                calories = dailyIntakeData.calories
                fat = dailyIntakeData.fat
                carbohydrate = dailyIntakeData.carbohydrate
                protein = dailyIntakeData.protein
                didLoadNonEmptyIntake = hasAnyData
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
        toggleOn = false
    }
    
    // MARK: - Save DailyIntake Data
    func saveDailyIntakeView() async {
        let trimmedCalories = calories.trimmedLeadingZeros
        let dailyIntakeData = DailyIntake(
            calories: trimmedCalories,
            fat: fat.trimmedLeadingZeros,
            carbohydrate: carbohydrate.trimmedLeadingZeros,
            protein: protein.trimmedLeadingZeros,
            macronutrientMetrics: toggleOn
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
        
        $toggleOn
            .sink { [weak self] isToggleOn in
                if isToggleOn {
                    self?.calculateCalories(
                        fat: self?.fat ?? "",
                        carbohydrate: self?.carbohydrate ?? "",
                        protein: self?.protein ?? ""
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    private func calculateCalories(
        fat: String,
        carbohydrate: String,
        protein: String
    ) {
        guard toggleOn else { return }
        
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
    
    // MARK: - Input Validation
    func validateInputs() -> String? {
        var invalidFields: [String] = []
        
        if !toggleOn {
            if !calories.isValidNumericInput() {
                invalidFields.append("Calorie")
            }
        } else {
            if !fat.isValidNumericInput() {
                invalidFields.append("Fat")
            }
            
            if !carbohydrate.isValidNumericInput() {
                invalidFields.append("Carbohydrate")
            }
            
            if !protein.isValidNumericInput() {
                invalidFields.append("Protein")
            }
        }
        
        guard !invalidFields.isEmpty else { return nil }
        
        let fieldList = formatList(invalidFields)
        
        return "Enter a valid \(fieldList) value."
    }
    
    private func formatList(_ items: [String]) -> String {
        switch items.count {
        case 0: return ""
        case 1: return items[0]
        case 2: return items.joined(separator: " and ")
        default:
            let allExceptLast = items.dropLast().joined(separator: ", ")
            
            return "\(allExceptLast) and \(items.last ?? "")"
        }
    }
    
    func handleDailyIntakeSave() -> Bool {
        if let errors = validateInputs() {
            alertMessage = errors
            showAlert = true
            return false
        }
        
        return true
    }
    
    private func handleToggleChange() {
        normalizeInputs()
        
        if toggleOn {
            calculateCalories(
                fat: fat,
                carbohydrate: carbohydrate,
                protein: protein
            )
        } else if calories.isEmpty {
            calories = ""
        }
    }
    
    // MARK: - Text
    func text(for calculatedIntake: String) -> String {
        let sanitized = calculatedIntake.doubleValue
        
        guard let intakeValue = sanitized, intakeValue > 0 else {
            return "Fill in the data"
        }
        
        if !toggleOn {
            guard calories.isValidNumericInput() else {
                return "Fill in the data"
            }
        }
        
        if validateInputs() != nil {
            return "Fill in the data"
        }
        
        let formattedValue = intakeValue.asWhole()
        
        return intakeValue == 1
        ? "\(formattedValue) calorie"
        : "\(formattedValue) calories"
    }
    
    var dailyIntakeText: String {
        text(for: calories)
    }
    
    var displayCalories: String {
        (calories.doubleValue ?? 0).asWhole()
    }
    
    // MARK: - UI Helper
    func titleColor(
        for value: String,
        isCalorie: Bool = false
    ) -> Color {
        let isValid = value.isValidNumericInput()
        let isValidInput = validateInputs() == nil
        
        if isCalorie && toggleOn {
            return isValidInput ? .primary : .secondary.opacity(0.5)
        }
        
        return isValid ? .secondary : .customRed
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
