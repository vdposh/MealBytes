//
//  RdiViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI
import Combine

final class RdiViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var age: String = ""
    @Published var selectedGender: Gender = .notSelected
    @Published var selectedActivity: Activity = .notSelected
    @Published var selectedWeightUnit: WeightUnit = .notSelected
    @Published var selectedHeightUnit: HeightUnit = .notSelected
    @Published var calculatedRdi: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isDataLoaded: Bool = false
    
    private let formatter = Formatter()
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    let mainViewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupDataObserver()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Load RDI Data
    func loadRdiView() async {
        do {
            let rdiData = try await firestore.loadRdiFirestore()
            await MainActor.run {
                self.calculatedRdi = rdiData.calculatedRdi
                self.age = rdiData.age
                self.selectedGender = Gender(
                    rawValue: rdiData.selectedGender
                ) ?? .notSelected
                self.selectedActivity = Activity(
                    rawValue: rdiData.selectedActivity
                ) ?? .notSelected
                self.weight = rdiData.weight
                self.selectedWeightUnit = WeightUnit(
                    rawValue: rdiData.selectedWeightUnit
                ) ?? .notSelected
                self.height = rdiData.height
                self.selectedHeightUnit = HeightUnit(
                    rawValue: rdiData.selectedHeightUnit
                ) ?? .notSelected
                isDataLoaded = true
            }
        } catch {
            await MainActor.run {
                appError = .decoding
                isDataLoaded = true
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
            try await firestore.saveRdiFirestore(rdiData)
            await MainActor.run {
                mainViewModel.rdi = calculatedRdi
            }
            await mainViewModel.saveMainRdiMainView()
        } catch {
            appError = .decoding
        }
    }
    
    // MARK: - RDI Calculation
    private func setupDataObserver() {
        Publishers.CombineLatest(
            Publishers.CombineLatest($age, $weight),
            Publishers.CombineLatest($height, $selectedGender)
        )
        .combineLatest(
            Publishers.CombineLatest(
                $selectedActivity,
                Publishers.CombineLatest($selectedWeightUnit,
                                         $selectedHeightUnit)
            )
        )
        .sink { [weak self] combined1, combined2 in
            let (age, weight) = combined1.0
            let (height, gender) = combined1.1
            let (activity, units) = combined2
            let (weightUnit, heightUnit) = units
            
            self?.recalculateRdi(
                age: age,
                weight: weight,
                height: height,
                gender: gender,
                activity: activity,
                weightUnit: weightUnit,
                heightUnit: heightUnit
            )
        }
        .store(in: &cancellables)
    }
    
    private func recalculateRdi(age: String,
                                weight: String,
                                height: String,
                                gender: Gender,
                                activity: Activity,
                                weightUnit: WeightUnit,
                                heightUnit: HeightUnit) {
        guard let ageValue = Double(age.sanitizedForDouble),
              let weightValue = Double(weight.sanitizedForDouble),
              let heightValue = Double(height.sanitizedForDouble),
              ageValue > 0, weightValue > 0, heightValue > 0,
              gender != .notSelected, activity != .notSelected else {
            self.calculatedRdi = ""
            return
        }
        
        let weightInKg = weightUnit ==
            .lbs ? weightValue * 0.453592 : weightValue
        let heightInCm = heightUnit ==
            .inches ? heightValue * 2.54 : heightValue
        
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
        return .secondary
    }
    
    // MARK: - Input Validation
    private func validateInputs() -> String? {
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
        
        if let ageValue = Double(age.sanitizedForDouble), ageValue > 120 {
            errorMessages.append("Enter a valid Age.")
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
        
        if let ageValue = Double(age.sanitizedForDouble), ageValue > 120 {
            return "Fill in the data"
        }
        
        switch rdiValue {
        case 1:
            return "\(calculatedRdi) calorie"
        default:
            return "\(calculatedRdi) calories"
        }
    }
    
    func color(for calculatedRdi: String) -> Color? {
        return calculatedRdi.isEmpty ? nil : .primary
    }
}

enum Gender: String, CaseIterable {
    case notSelected = "Not selected"
    case male = "Male"
    case female = "Female"
    
    var accentColor: Color {
        switch self {
        case .notSelected:
            return .customRed
        case .male, .female:
            return .customGreen
        }
    }
}

enum Activity: String, CaseIterable {
    case notSelected = "Not selected"
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"
    case extraActive = "Extra Active"
    
    var accentColor: Color {
        switch self {
        case .notSelected:
            return .customRed
        default:
            return .customGreen
        }
    }
}

enum WeightUnit: String, CaseIterable {
    case notSelected = "Not selected"
    case kg = "kg"
    case lbs = "lbs"
    
    var accentColor: Color {
        switch self {
        case .notSelected:
            return .customRed
        default:
            return .customGreen
        }
    }
}

enum HeightUnit: String, CaseIterable {
    case notSelected = "Not selected"
    case cm = "cm"
    case inches = "inches"
    
    var accentColor: Color {
        switch self {
        case .notSelected:
            return .customRed
        default:
            return .customGreen
        }
    }
}

#Preview {
    NavigationStack {
        RdiView()
    }
}
