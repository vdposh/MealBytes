//
//  DailyIntakeViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI
import Combine

protocol DailyIntakeViewModelProtocol {
    func loadDailyIntakeView() async
    func saveDailyIntakeView() async
    func conditionallyClearDailyIntake()
    func clearDailyIntake()
    func dailyIntakeText() -> String
}

final class DailyIntakeViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var previousFocus: MacronutrientsFocus?
    @Published var calories: String = ""
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
    @Published var protein: String = ""
    @Published var originalCalories: String = ""
    @Published var originalFat: String = ""
    @Published var originalCarbohydrate: String = ""
    @Published var originalProtein: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var didSaveSuccessfully: Bool = false
    @Published var didLoadNonEmptyIntake: Bool = false
    @Published var toggleOn: Bool = false {
        didSet {
            handleToggleOnChange()
        }
    }
    
    private let formatter = Formatter()
    
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
        
        let fatValue = Double(fat.sanitizedForDouble) ?? 0
        let carbValue = Double(carbohydrate.sanitizedForDouble) ?? 0
        let protValue = Double(protein.sanitizedForDouble) ?? 0
        let totalCalories = (fatValue * 9) + (carbValue * 4) + (protValue * 4)
        
        calories = formatter.roundedValue(totalCalories)
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
    
    func handleSave() -> Bool {
        if let errors = validateInputs() {
            alertMessage = errors
            showAlert = true
            return false
        }
        return true
    }
    
    // MARK: - Toggle
    private func handleToggleOnChange() {
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
    
    func restoreInputsIfNeeded() {
        if fat.isEmpty {
            fat = originalFat
        }
        if carbohydrate.isEmpty {
            carbohydrate = originalCarbohydrate
        }
        if protein.isEmpty {
            protein = originalProtein
        }
        if calories.isEmpty {
            calories = originalCalories
        }
    }
    
    // MARK: - Text
    func text(for calculatedIntake: String) -> String {
        let sanitized = calculatedIntake.sanitizedForDouble
        guard let intakeValue = Double(sanitized), intakeValue > 0 else {
            return "Fill in the data"
        }
        
        if !toggleOn {
            guard calories.isValidNumericInput() else {
                return "Fill in the data"
            }
        }
        
        return intakeValue == 1
        ? "\(calculatedIntake) calorie"
        : "\(calculatedIntake) calories"
    }
    
    func dailyIntakeText() -> String {
        text(for: calories)
    }
    
    // MARK: - UI Helper
    func titleColor(
        for value: String,
        isCalorie: Bool = false
    ) -> Color {
        if isCalorie && toggleOn {
            return .secondary
        }
        
        return value.isValidNumericInput() ? .secondary : .customRed
    }
    
    var caloriesTextColor: Color {
        switch toggleOn {
        case true: .secondary
        case false: .primary
        }
    }
    
    var showStar: Bool {
        !toggleOn
    }
    
    var footerText: String {
        toggleOn
        ? "Calories will be calculated automatically based on the entered macronutrients."
        : "Necessary calorie amount can be entered directly."
    }
    
    // MARK: - Keyboard
    func normalizeInputs() {
        calories = calories.trimmedLeadingZeros
        fat = fat.trimmedLeadingZeros
        carbohydrate = carbohydrate.trimmedLeadingZeros
        protein = protein.trimmedLeadingZeros
    }
    
    // MARK: - Focus
    func handleCaloriesFocusChange(to isFocused: Bool) {
        updateInputOnFocusChange(
            value: &calories,
            original: &originalCalories,
            didGainFocus: isFocused
        )
    }
    
    func handleMacronutrientFocusChange(
        focus: MacronutrientsFocus,
        didGainFocus: Bool
    ) {
        normalizeInputs()
        
        switch focus {
        case .fat:
            updateInputOnFocusChange(
                value: &fat,
                original: &originalFat,
                didGainFocus: didGainFocus
            )
            
        case .carbohydrate:
            updateInputOnFocusChange(
                value: &carbohydrate,
                original: &originalCarbohydrate,
                didGainFocus: didGainFocus
            )
            
        case .protein:
            updateInputOnFocusChange(
                value: &protein,
                original: &originalProtein,
                didGainFocus: didGainFocus
            )
        }
    }
    
    private func updateInputOnFocusChange(
        value: inout String,
        original: inout String,
        didGainFocus: Bool
    ) {
        if didGainFocus {
            original = value
            value = ""
        } else {
            let sanitized = Double(value.sanitizedForDouble)
            value = (sanitized != nil && sanitized! > 0) ? value : original
        }
    }
}

extension DailyIntakeViewModel: DailyIntakeViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    let mainViewModel = MainViewModel()
    let dailyIntakeViewModel = DailyIntakeViewModel(
        mainViewModel: mainViewModel
    )
    
    return NavigationStack {
        DailyIntakeView(dailyIntakeViewModel: dailyIntakeViewModel)
    }
}
