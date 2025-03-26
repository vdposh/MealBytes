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
    @Published var selectedGender: Gender = .notSelected
    @Published var selectedActivity: ActivityLevel = .notSelected
    @Published var selectedWeightUnit: WeightUnit = .kg
    @Published var selectedHeightUnit: HeightUnit = .cm
    @Published var calculatedRdi: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isDataLoaded = false
    var isError: Bool = false
    
    private let formatter: Formatter
    private let firestoreManager: FirestoreManagerProtocol
    private let mainViewModel: MainViewModel
    
    init(formatter: Formatter = Formatter(),
         firestoreManager: FirestoreManagerProtocol,
         mainViewModel: MainViewModel) {
        self.formatter = formatter
        self.firestoreManager = firestoreManager
        self.mainViewModel = mainViewModel
    }
    
    // MARK: - Load RDI Data
    func loadRdiView() async {
        do {
            let rdiData = try await firestoreManager.loadRdiFirebase()
            await MainActor.run {
                self.calculatedRdi = rdiData.calculatedRdi
                self.age = rdiData.age
                self.selectedGender = Gender(
                    rawValue: rdiData.selectedGender
                ) ?? .notSelected
                self.selectedActivity = ActivityLevel(
                    rawValue: rdiData.selectedActivity
                ) ?? .notSelected
                self.weight = rdiData.weight
                self.selectedWeightUnit = WeightUnit(
                    rawValue: rdiData.selectedWeightUnit
                ) ?? .kg
                self.height = rdiData.height
                self.selectedHeightUnit = HeightUnit(
                    rawValue: rdiData.selectedHeightUnit
                ) ?? .cm
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Save RDI Data
    func saveRdiView() async {
        let rdiData = RdiData(
            calculatedRdi: calculatedRdi,
            age: age,
            selectedGender: selectedGender.rawValue,
            selectedActivity: selectedActivity.rawValue,
            weight: weight,
            selectedWeightUnit: selectedWeightUnit.rawValue,
            height: height,
            selectedHeightUnit: selectedHeightUnit.rawValue
        )
        
        do {
            try await firestoreManager.saveRdiFirebase(rdiData)
            await MainActor.run {
                mainViewModel.rdi = calculatedRdi
            }
            await mainViewModel.saveMainRdiMainView()
        } catch {
            appError = .decoding
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
            if value.isEmpty {
                errorMessages.append(errorMessage)
            } else if Double(value) == nil {
                errorMessages.append(errorMessage)
            } else if Double(value) == 0 {
                errorMessages.append(errorMessage)
            }
        }
        
        if selectedGender == .notSelected {
            errorMessages.append("Select a Gender.")
        }
        
        if selectedActivity == .notSelected {
            errorMessages.append("Select an Activity Level.")
        }
        
        if errorMessages.isEmpty {
            return nil
        } else {
            return errorMessages.joined(separator: "\n")
        }
    }
    
    // MARK: - Internal Calculation
    private func calculateRdiInternal(weightValue: Double,
                                      heightValue: Double,
                                      ageValue: Double,
                                      gender: Gender,
                                      activityLevel: ActivityLevel) {
        guard gender != .notSelected, activityLevel != .notSelected else {
            calculatedRdi = "Error: Gender or Activity Level not selected"
            return
        }
        
        let weightInKg = selectedWeightUnit == .lbs ? weightValue * 0.453592 : weightValue
        let heightInCm = selectedHeightUnit == .inches ? heightValue * 2.54 : heightValue
        
        let bmr: Double
        switch gender {
        case .male:
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * ageValue + 5
        case .female:
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * ageValue - 161
        case .notSelected:
            fatalError("This case should never be reached because of the guard statement.")
        }
        
        let activityFactor: Double
        switch activityLevel {
        case .sedentary: activityFactor = 1.2
        case .lightlyActive: activityFactor = 1.375
        case .moderatelyActive: activityFactor = 1.55
        case .veryActive: activityFactor = 1.725
        case .extraActive: activityFactor = 1.9
        case .notSelected:
            fatalError("This case should never be reached because of the guard statement.")
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
              let ageValue = Double(sanitizedAge) else {
            alertMessage = "There was an error processing the input values."
            showAlert = true
            return
        }
        
        if selectedGender == .notSelected {
            alertMessage = "Select a valid Gender."
            showAlert = true
            return
        }
        
        if selectedActivity == .notSelected {
            alertMessage = "Select a valid Activity Level."
            showAlert = true
            return
        }
        
        calculateRdiInternal(weightValue: weightValue,
                             heightValue: heightValue,
                             ageValue: ageValue,
                             gender: selectedGender,
                             activityLevel: selectedActivity)
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
        if isError {
            return "Error"
        } else {
            return "Done"
        }
    }
    
    func handleSave() -> Bool {
        if let errors = validateInputs() {
            isError = true
            alertMessage = "Please fill all required fields and Calculate RDI first.\n\n\(errors)"
            showAlert = true
            return false
        } else if calculatedRdi.isEmpty {
            isError = true
            alertMessage = "Please calculate RDI before saving."
            showAlert = true
            return false
        } else {
            isError = false
            return true
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

enum Gender: String, CaseIterable {
    case notSelected = "Not selected"
    case male = "Male"
    case female = "Female"
}

enum ActivityLevel: String, CaseIterable {
    case notSelected = "Not selected"
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"
    case extraActive = "Extra Active"
}

enum WeightUnit: String, CaseIterable {
    case kg = "kg"
    case lbs = "lbs"
}

enum HeightUnit: String, CaseIterable {
    case cm = "cm"
    case inches = "inches"
}

#Preview {
    NavigationStack {
        RdiView(
            rdiViewModel: RdiViewModel(
                firestoreManager: FirestoreManager(),
                mainViewModel: MainViewModel(
                    firestoreManager: FirestoreManager()
                )
            )
        )
    }
    .accentColor(.customGreen)
}
