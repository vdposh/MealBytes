//
//  RdiViewModel.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

class RdiViewModel: ObservableObject {
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var age: String = ""
    @Published var selectedGender: String? = nil
    @Published var selectedActivity: String? = nil
    @Published var selectedWeightUnit: String = "kg"
    @Published var selectedHeightUnit: String = "cm"
    @Published var calculatedRdi: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
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
        
        calculatedRdi = String(format: "%.0f", bmr * activityFactor)
    }
    
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
}

#Preview {
    NavigationStack {
        RdiView(viewModel: RdiViewModel())
    }
    .accentColor(.customGreen)
}
