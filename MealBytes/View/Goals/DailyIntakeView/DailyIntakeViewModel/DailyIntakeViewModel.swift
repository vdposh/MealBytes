//
//  DailyIntakeViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI
import Combine

final class DailyIntakeViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var calories: String = ""
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
    @Published var protein: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isDataLoaded: Bool = false
    @Published var toggleOn: Bool = false {
        didSet {
            normalizeInputs()
            if toggleOn {
                calculateCalories(fat: fat,
                                  carbohydrate: carbohydrate,
                                  protein: protein)
            } else if calories.isEmpty {
                calories = ""
            }
        }
    }
    
    private let formatter = Formatter()
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let mainViewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        setupBindings()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Load DailyIntake Data
    func loadDailyIntakeView() async {
        do {
            let dailyIntakeData = try await firestore.loadDailyIntakeFirestore()
            await MainActor.run {
                toggleOn = dailyIntakeData.macronutrientMetrics
                calories = dailyIntakeData.calories
                fat = dailyIntakeData.fat
                carbohydrate = dailyIntakeData.carbohydrate
                protein = dailyIntakeData.protein
                isDataLoaded = true
            }
        } catch {
            await MainActor.run {
                appError = .decoding
                isDataLoaded = true
            }
        }
    }
    
    // MARK: - Save DailyIntake Data
    func saveDailyIntakeView() async {
        let dailyIntakeData = DailyIntake(
            calories: calories.trimmedLeadingZeros,
            fat: fat.trimmedLeadingZeros,
            carbohydrate: carbohydrate.trimmedLeadingZeros,
            protein: protein.trimmedLeadingZeros,
            macronutrientMetrics: toggleOn
        )
        
        do {
            try await firestore.saveDailyIntakeFirestore(dailyIntakeData)
            await MainActor.run {
                mainViewModel.intake = calories
            }
            await mainViewModel
                .saveCurrentIntakeMainView(source: "dailyIntakeView")
        } catch {
            await MainActor.run {
                appError = .decoding
            }
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
    
    // MARK: - Calculations
    private func calculateCalories(fat: String,
                                   carbohydrate: String,
                                   protein: String) {
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
    
    // MARK: - UI Helpers
    func titleColor(for value: String,
                    isCalorie: Bool = false) -> Color {
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
    
    var underlineOpacity: Double {
        toggleOn ? 0.6 : 1.0
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
    func handleMacronutrientFocusChange(focus: MacronutrientsFocus,
                                        didGainFocus: Bool) {
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
