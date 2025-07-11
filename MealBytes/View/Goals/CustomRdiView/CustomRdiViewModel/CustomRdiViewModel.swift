//
//  CustomRdiViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI
import Combine

final class CustomRdiViewModel: ObservableObject {
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
                calories = "0"
            }
        }
    }
    
    private let formatter = Formatter()
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    let mainViewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        calories = "0"
        fat = ""
        carbohydrate = ""
        protein = ""
        setupBindings()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Load CustomGoals Data
    func loadCustomRdiView() async {
        do {
            let customGoalsData = try await firestore.loadCustomRdiFirestore()
            await MainActor.run {
                toggleOn = customGoalsData.macronutrientMetrics
                calories = customGoalsData.calories
                fat = customGoalsData.fat
                carbohydrate = customGoalsData.carbohydrate
                protein = customGoalsData.protein
                isDataLoaded = true
            }
        } catch {
            await MainActor.run {
                appError = .decoding
                isDataLoaded = true
            }
        }
    }
    
    // MARK: - Save Textfields Info
    func saveCustomRdiView() async {
        let customGoalsData = CustomRdiData(
            calories: calories.trimmedLeadingZeros,
            fat: fat.trimmedLeadingZeros,
            carbohydrate: carbohydrate.trimmedLeadingZeros,
            protein: protein.trimmedLeadingZeros,
            macronutrientMetrics: toggleOn
        )
        
        do {
            try await firestore.saveCustomRdiFirestore(customGoalsData)
            await MainActor.run {
                mainViewModel.rdi = calories
            }
            await mainViewModel.saveMainRdiMainView()
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
    func text(for calculatedRdi: String) -> String {
        let sanitized = calculatedRdi.sanitizedForDouble
        
        guard let rdiValue = Double(sanitized),
              rdiValue > 0,
              calories.isValidNumericInput(),
              fat.isValidNumericInput(),
              carbohydrate.isValidNumericInput(),
              protein.isValidNumericInput() else {
            return "Fill in the data"
        }
        
        switch rdiValue {
        case 1:
            return "\(calculatedRdi) calorie"
        default:
            return "\(calculatedRdi) calories"
        }
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
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel(),
        goalsViewModel: GoalsViewModel()
    )
    .environmentObject(ThemeManager())
}

#Preview {
    NavigationStack {
        CustomRdiView()
    }
}
