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
            let customGoalsData = try await firestore
                .loadCustomRdiFirestore()
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
            calories: calories,
            fat: fat,
            carbohydrate: carbohydrate,
            protein: protein,
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
        guard toggleOn else {
            return
        }
        
        let fatValue = Double(fat.sanitizedForDouble) ?? 0
        let carbValue = Double(carbohydrate.sanitizedForDouble) ?? 0
        let protValue = Double(protein.sanitizedForDouble) ?? 0
        let totalCalories = (fatValue * 9) + (carbValue * 4) + (protValue * 4)
        calories = formatter.formattedValue(totalCalories, unit: .empty)
    }
    
    // MARK: - Input Validation
    func validateInputs() -> String? {
        var errorMessages: [String] = []
        
        if !toggleOn {
            if calories.sanitizedForDouble.isEmpty ||
                Double(calories.sanitizedForDouble) == nil ||
                Double(calories.sanitizedForDouble) == 0 {
                errorMessages.append("Enter a valid calorie value.")
            }
        } else {
            let macronutrients: [(String, String)] = [
                (fat.sanitizedForDouble,
                 "Enter a valid fat value."),
                (carbohydrate.sanitizedForDouble,
                 "Enter a valid carbohydrate value."),
                (protein.sanitizedForDouble,
                 "Enter a valid protein value.")
            ]
            for (value, errorMessage) in macronutrients {
                if value.isEmpty || Double(value) == nil || Double(value) == 0 {
                    errorMessages.append(errorMessage)
                }
            }
        }
        
        if errorMessages.isEmpty {
            return nil
        } else {
            return errorMessages.joined(separator: "\n")
        }
    }
    
    func handleSave() -> Bool {
        if let errors = validateInputs() {
            alertMessage = errors
            showAlert = true
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Text
    func text(for calculatedRdi: String) -> String {
        guard let rdiValue = Double(calculatedRdi.sanitizedForDouble),
              rdiValue > 0 else {
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
            return Color.secondary
        } else if value.isEmpty ||
                    Double(value.sanitizedForDouble) == nil ||
                    Double(value.sanitizedForDouble) == 0 {
            return Color.customRed
        } else {
            return Color.secondary
        }
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
        return !toggleOn
    }
    
    var footerText: String {
        toggleOn
        ? "Calories will be calculated automatically based on the entered macronutrients."
        : "Necessary calorie amount can be entered directly."
    }
}

#Preview {
    NavigationStack {
        CustomRdiView()
    }
}
