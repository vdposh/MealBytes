//
//  RdiViewModel.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI
import Combine

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
    
    private let formatter = Formatter()
    
    private let firebase: FirestoreFirebaseProtocol = FirestoreFirebase()
    let mainViewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupDataObserver()
    }
    
    // MARK: - Load RDI Data
    func loadRdiView() async {
        do {
            let rdiData = try await firebase.loadRdiFirebase()
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
            try await firebase.saveRdiFirebase(rdiData)
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
            if value.isEmpty || Double(value) == nil || Double(value) == 0 {
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
    
    // MARK: - RDI Calculation
    private func setupDataObserver() {
        Publishers.CombineLatest4(
            $age,
            $weight,
            $height,
            Publishers.CombineLatest($selectedGender, $selectedActivity)
        )
        .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        .sink { [weak self] age, weight, height, combined in
            let (gender, activity) = combined
            self?.recalculateRdi(age: age,
                                 weight: weight,
                                 height: height,
                                 gender: gender,
                                 activity: activity)
        }
        .store(in: &cancellables)
    }
    
    private func recalculateRdi(age: String,
                                weight: String,
                                height: String,
                                gender: Gender,
                                activity: ActivityLevel) {
        guard let ageValue = Double(age.sanitizedForDouble),
              let weightValue = Double(weight.sanitizedForDouble),
              let heightValue = Double(height.sanitizedForDouble),
              gender != .notSelected, activity != .notSelected else {
            self.calculatedRdi = ""
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
            return
        }
        
        let activityFactor: Double
        switch activity {
        case .sedentary: activityFactor = 1.2
        case .lightlyActive: activityFactor = 1.375
        case .moderatelyActive: activityFactor = 1.55
        case .veryActive: activityFactor = 1.725
        case .extraActive: activityFactor = 1.9
        case .notSelected:
            return
        }
        
        self.calculatedRdi = formatter.roundedValue(bmr * activityFactor)
    }
    
    // MARK: - Field Title Styling
    func fieldTitleColor(for field: String) -> Color {
        let sanitizedField = field.sanitizedForDouble
        guard let value = Double(sanitizedField), value > 0 else {
            return .customRed
        }
        return .primary
    }
    
    // MARK: - Save Goals
    func saveGoalsAlert() {
        alertMessage = "Your goals have been saved successfully!"
        showAlert = true
        isError = false
    }
    
    func handleSave() -> Bool {
        if let errors = validateInputs() {
            isError = true
            alertMessage = errors
            showAlert = true
            return false
        } else {
            isError = false
            return true
        }
    }
    
    func alertTitle() -> String {
        if isError {
            return "Error"
        } else {
            return "Done"
        }
    }
    
    // MARK: - Text Style
    func text(for calculatedRdi: String) -> String {
        switch calculatedRdi.isEmpty {
        case true:
            "Fill in the data"
        case false:
            "\(calculatedRdi) calories"
        }
    }
    
    func color(for calculatedRdi: String) -> Color {
        switch calculatedRdi.isEmpty {
        case true:
                .secondary
        case false:
                .primary
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
