//
//  RdiViewModel.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

final class RdiViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var age: String = ""
    @Published var selectedGender: String? = nil
    @Published var selectedActivity: String? = nil
    @Published var selectedWeightUnit: String = "kg"
    @Published var selectedHeightUnit: String = "cm"
    @Published var calculatedRdi: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isDataLoaded = false

    let genders = ["Male", "Female"]
    let activityLevels = [
        "Sedentary",
        "Lightly Active",
        "Moderately Active",
        "Very Active",
        "Extra Active"
    ]
    let weightUnits = ["kg", "lbs"]
    let heightUnits = ["cm", "inches"]
    
    private let formatter: Formatter
    private let firestoreManager: FirestoreManagerProtocol
    let mainViewModel: MainViewModel
    
    init(formatter: Formatter = Formatter(),
         firestoreManager: FirestoreManagerProtocol = FirestoreManager(),
         mainViewModel: MainViewModel) {
        self.formatter = formatter
        self.firestoreManager = firestoreManager
        self.mainViewModel = mainViewModel
    }
    
    // MARK: - Save RDI Data
    func saveRdiView() async {
        let rdiData = RdiData(
            calculatedRdi: calculatedRdi,
            age: age,
            selectedGender: selectedGender ?? "",
            selectedActivity: selectedActivity ?? "",
            weight: weight,
            selectedWeightUnit: selectedWeightUnit,
            height: height,
            selectedHeightUnit: selectedHeightUnit
        )
        
        do {
            try await firestoreManager.saveRdiFirebase(rdiData)
        } catch {
            appError = .decoding
        }
    }
    
    // MARK: - Load RDI Data
    func loadRdiView() async {
        do {
            let rdiData = try await firestoreManager.loadRdiFirebase()
            await MainActor.run {
                self.calculatedRdi = rdiData.calculatedRdi
                self.age = rdiData.age
                self.selectedGender = rdiData.selectedGender
                self.selectedActivity = rdiData.selectedActivity
                self.weight = rdiData.weight
                self.selectedWeightUnit = rdiData.selectedWeightUnit
                self.height = rdiData.height
                self.selectedHeightUnit = rdiData.selectedHeightUnit
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Input Validation
    func validateInputs() -> String? {
        var errorMessages: [String] = []
        let inputs: [(String, String)] = [
            (age.sanitizedForDouble, "Enter a valid Age."),
            (weight.sanitizedForDouble, "Enter a valid Weight."),
            (height.sanitizedForDouble, "Enter a valid Height.")
        ]
        
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
        
        if selectedGender == nil {
            errorMessages.append("Select a Gender.")
        }
        
        if selectedActivity == nil {
            errorMessages.append("Select an Activity Level.")
        }
        
        switch errorMessages.isEmpty {
        case true:
            return nil
        case false:
            return errorMessages.joined(separator: "\n")
        }
    }
    
    // MARK: - Internal Calculation
    private func calculateRdiInternal(weightValue: Double,
                                      heightValue: Double,
                                      ageValue: Double,
                                      gender: String,
                                      activityLevel: String) {
        let weightInKg = selectedWeightUnit == "lbs" ? weightValue * 0.453592 : weightValue
        let heightInCm = selectedHeightUnit == "inches" ? heightValue * 2.54 : heightValue
        
        let bmr: Double
        if gender == "Male" {
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * ageValue + 5
        } else {
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * ageValue - 161
        }
        
        let activityFactor: Double
        switch activityLevel {
        case "Sedentary": activityFactor = 1.2
        case "Lightly Active": activityFactor = 1.375
        case "Moderately Active": activityFactor = 1.55
        case "Very Active": activityFactor = 1.725
        case "Extra Active": activityFactor = 1.9
        default: activityFactor = 1.2
        }
        
        calculatedRdi = formatter.roundedValue(bmr * activityFactor)
    }
    
    // MARK: - RDI Calculation
    func calculateRdi() {
        if let errors = validateInputs() {
            alertMessage = errors
            showAlert = true
            return
        }
        
        let sanitizedWeight = weight.sanitizedForDouble
        let sanitizedHeight = height.sanitizedForDouble
        let sanitizedAge = age.sanitizedForDouble
        
        guard let weightValue = Double(sanitizedWeight),
              let heightValue = Double(sanitizedHeight),
              let ageValue = Double(sanitizedAge),
              let gender = selectedGender,
              let activityLevel = selectedActivity else {
            alertMessage = "There was an error processing the input values."
            showAlert = true
            return
        }
        
        calculateRdiInternal(weightValue: weightValue,
                             heightValue: heightValue,
                             ageValue: ageValue,
                             gender: gender,
                             activityLevel: activityLevel)
    }
    
    // MARK: - Field Title Styling
    func fieldTitleColor(for field: String) -> Color {
        let sanitizedField = field.sanitizedForDouble
        switch true {
        case sanitizedField.isEmpty,
            Double(sanitizedField) == nil,
            Double(sanitizedField)! <= 0:
            return .customRed
        default:
            return .primary
        }
    }
    
    // MARK: - Save Goals
    func validateBeforeSave() -> String? {
        switch calculatedRdi.isEmpty {
        case true:
            return "Calculate RDI first"
        case false:
            return nil
        }
    }
    
    func saveGoalsAlert() {
        switch validateBeforeSave() {
        case let error?:
            alertMessage = error
            showAlert = true
        case nil:
            alertMessage = "Your goals have been saved successfully!"
            showAlert = true
        }
    }
    
    func alertTitle() -> String {
        switch alertMessage.contains("Error") {
        case true:
            "Error"
        case false:
            "Done"
        }
    }
    
    // MARK: - Text Style
    func text(for calculatedRdi: String) -> String {
        switch calculatedRdi.isEmpty {
        case true:
            return "Fill in the data"
        case false:
            return "\(calculatedRdi) calories"
        }
    }
    
    func font(for calculatedRdi: String) -> Font {
        switch calculatedRdi.isEmpty {
        case true:
            return .callout
        case false:
            return .callout
        }
    }
    
    func color(for calculatedRdi: String) -> Color {
        switch calculatedRdi.isEmpty {
        case true:
            return .secondary
        case false:
            return .primary
        }
    }
    
    func weight(for calculatedRdi: String) -> Font.Weight {
        switch calculatedRdi.isEmpty {
        case true:
            return .regular
        case false:
            return .semibold
        }
    }
}

#Preview {
    NavigationStack {
        RdiView(rdiViewModel: RdiViewModel(
            mainViewModel: MainViewModel())
        )
    }
    .accentColor(.customGreen)
}
