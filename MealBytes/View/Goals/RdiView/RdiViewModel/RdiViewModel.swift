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
                    rawValue: rdiData.selectedGender) ?? .notSelected
                self.selectedActivity = Activity(
                    rawValue: rdiData.selectedActivity) ?? .notSelected
                self.weight = rdiData.weight.preparedForLocaleDecimal
                self.selectedWeightUnit = WeightUnit(
                    rawValue: rdiData.selectedWeightUnit) ?? .notSelected
                self.height = rdiData.height.preparedForLocaleDecimal
                self.selectedHeightUnit = HeightUnit(
                    rawValue: rdiData.selectedHeightUnit) ?? .notSelected
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
            age: age.trimmedLeadingZeros,
            selectedGender: selectedGender.rawValue,
            selectedActivity: selectedActivity.rawValue,
            weight: weight.trimmedLeadingZeros,
            selectedWeightUnit: selectedWeightUnit.rawValue,
            height: height.trimmedLeadingZeros,
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
                Publishers.CombineLatest(
                    $selectedWeightUnit,
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
        guard isInputValidForCalculation,
              gender != .notSelected,
              activity != .notSelected else {
            calculatedRdi = ""
            return
        }
        
        let ageValue = Double(age.sanitizedForDouble) ?? 0
        let weightValue = Double(weight.sanitizedForDouble) ?? 0
        let heightValue = Double(height.sanitizedForDouble) ?? 0
        
        let weightInKg = weightUnit == .lbs
        ? weightValue * 0.453592
        : weightValue
        let heightInCm = heightUnit == .inches
        ? heightValue * 2.54
        : heightValue
        
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
        case .notSelected: return
        }
        
        self.calculatedRdi = formatter.roundedValue(
            max(1, bmr * activityFactor)
        )
    }
    
    // MARK: - Input Validation
    private func validateInputs() -> String? {
        var errorMessages: [String] = []
        
        if !age.isValidNumericInput(in: 1...120) {
            errorMessages.append("Enter a valid Age.")
        }
        
        if !weight.isValidNumericInput() {
            errorMessages.append("Enter a valid Weight.")
        }
        
        if !height.isValidNumericInput() {
            errorMessages.append("Enter a valid Height.")
        }
        
        if selectedGender == .notSelected {
            errorMessages.append("Select a Gender.")
        }
        
        if selectedActivity == .notSelected {
            errorMessages.append("Select an Activity Level.")
        }
        
        if selectedWeightUnit == .notSelected {
            errorMessages.append("Select a Weight Unit.")
        }
        
        if selectedHeightUnit == .notSelected {
            errorMessages.append("Select a Height Unit.")
        }
        
        return errorMessages.isEmpty ? nil : errorMessages.joined(
            separator: "\n"
        )
    }
    
    private var isInputValidForCalculation: Bool {
        age.isValidNumericInput(in: 1...120) &&
        weight.isValidNumericInput() &&
        height.isValidNumericInput()
    }
    
    func handleSave() -> Bool {
        if let errors = validateInputs() {
            alertMessage = errors
            showAlert = true
            return false
        }
        return true
    }
    
    // MARK: - Keyboard
    func normalizeInputs() {
        age = age.trimmedLeadingZeros
        weight = weight.trimmedLeadingZeros
        height = height.trimmedLeadingZeros
    }
    
    // MARK: - Field Title Styling
    func fieldTitleColor(for field: String) -> Color {
        let isAge = field == age
        if isAge {
            return field.isValidNumericInput(in: 1...120) ?
                .secondary : .customRed
        } else {
            return field.isValidNumericInput() ?
                .secondary : .customRed
        }
    }
    
    // MARK: - Text
    func text(for calculatedRdi: String) -> String {
        guard let rdiValue = Double(calculatedRdi.sanitizedForDouble),
              rdiValue > 0,
              isInputValidForCalculation,
              selectedWeightUnit != .notSelected,
              selectedHeightUnit != .notSelected else {
            return "Fill in the data"
        }
        
        return rdiValue == 1
        ? "\(calculatedRdi) calorie"
        : "\(calculatedRdi) calories"
    }
    
    func color(for calculatedRdi: String) -> Color? {
        guard !calculatedRdi.isEmpty,
              isInputValidForCalculation,
              selectedWeightUnit != .notSelected,
              selectedHeightUnit != .notSelected else {
            return .secondary
        }
        
        return .primary
    }
}

#Preview {
    NavigationStack {
        RdiView()
    }
}
