//
//  RdiViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI
import Combine

protocol RdiViewModelProtocol {
    var rdiText: String { get }
    
    func loadRdiView() async
    func saveRdiView() async
    func clearRdi()
    func conditionallyClearRdi()
}

final class RdiViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var age: String = ""
    @Published var weight: String = ""
    @Published var height: String = ""
    @Published var selectedGender: Gender = .notSelected
    @Published var selectedActivity: Activity = .notSelected
    @Published var selectedWeightUnit: WeightUnit = .kg
    @Published var selectedHeightUnit: HeightUnit = .cm
    @Published var calculatedRdi: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var didSaveSuccessfully: Bool = false
    @Published var didLoadNonEmptyRdi: Bool = false
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let mainViewModel: MainViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
        
        setupBindingsRdiView()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Load RDI Data
    func loadRdiView() async {
        do {
            let rdiData = try await firestore.loadRdiFirestore()
            let hasAnyData = !rdiData.calculatedRdi.isEmpty
            
            await MainActor.run {
                self.calculatedRdi = rdiData.calculatedRdi
                self.age = rdiData.age
                self.selectedGender = Gender(
                    rawValue: rdiData.selectedGender
                ) ?? .notSelected
                self.selectedActivity = Activity(
                    rawValue: rdiData.selectedActivity
                ) ?? .notSelected
                self.weight = (Double(rdiData.weight) ?? 0).asDecimal()
                self.selectedWeightUnit = WeightUnit(
                    rawValue: rdiData.selectedWeightUnit
                ) ?? .kg
                self.height = (Double(rdiData.height) ?? 0).asDecimal()
                self.selectedHeightUnit = HeightUnit(
                    rawValue: rdiData.selectedHeightUnit
                ) ?? .cm
                self.didLoadNonEmptyRdi = hasAnyData
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    func conditionallyClearRdi() {
        if !didSaveSuccessfully && !didLoadNonEmptyRdi {
            clearRdi()
        }
        
        didSaveSuccessfully = false
        didLoadNonEmptyRdi = false
    }
    
    func clearRdi() {
        calculatedRdi = ""
        age = ""
        weight = ""
        height = ""
        selectedGender = .notSelected
        selectedActivity = .notSelected
        selectedWeightUnit = .kg
        selectedHeightUnit = .cm
    }
    
    // MARK: - Save RDI Data
    func saveRdiView() async {
        let stableRdi = String(calculatedRdi.doubleValue ?? 0)
        
        let rdiData = RdiData(
            calculatedRdi: stableRdi,
            age: age.trimmedLeadingZeros,
            selectedGender: selectedGender.rawValue,
            selectedActivity: selectedActivity.rawValue,
            weight: String(weight.doubleValue ?? 0),
            selectedWeightUnit: selectedWeightUnit.rawValue,
            height: String(height.doubleValue ?? 0),
            selectedHeightUnit: selectedHeightUnit.rawValue
        )
        
        do {
            try await firestore.saveRdiFirestore(rdiData)
            
            await MainActor.run {
                mainViewModel.updateIntake(to: stableRdi)
                didSaveSuccessfully = true
            }
            
            await mainViewModel.saveCurrentIntakeMainView(source: "rdiView")
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Calculation
    private func setupBindingsRdiView() {
        Publishers.CombineLatest(
            Publishers.CombineLatest($age, $weight),
            Publishers.CombineLatest($height, $selectedGender)
        )
        .combineLatest(
            Publishers.CombineLatest(
                $selectedActivity,
                Publishers.CombineLatest(
                    $selectedWeightUnit,
                    $selectedHeightUnit
                )
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
    
    private func recalculateRdi(
        age: String,
        weight: String,
        height: String,
        gender: Gender,
        activity: Activity,
        weightUnit: WeightUnit,
        heightUnit: HeightUnit
    ) {
        guard isInputValidForCalculation,
              gender != .notSelected,
              activity != .notSelected else {
            calculatedRdi = ""
            return
        }
        
        let ageValue = age.doubleValue ?? 0
        let weightValue = weight.doubleValue ?? 0
        let heightValue = height.doubleValue ?? 0
        let weightInKg = weightUnit == .lbs
        ? weightValue * 0.453592
        : weightValue
        let heightInCm = heightUnit == .inches
        ? heightValue * 2.54
        : heightValue
        let bmr: Double
        let activityFactor: Double
        
        switch gender {
        case .male:
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * ageValue + 5
        case .female:
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * ageValue - 161
        case .notSelected: return
        }
        
        switch activity {
        case .sedentary: activityFactor = 1.2
        case .lightlyActive: activityFactor = 1.375
        case .moderatelyActive: activityFactor = 1.55
        case .veryActive: activityFactor = 1.725
        case .extraActive: activityFactor = 1.9
        case .notSelected: return
        }
        
        self.calculatedRdi = (max(1, bmr * activityFactor)).asWhole()
    }
    
    // MARK: - Input Validation
    private func validateInputs() -> String? {
        var invalidFields: [String] = []
        var missingSelections: [String] = []
        
        if !age.isValidNumericInput(in: 1...120) {
            invalidFields.append("Age")
        }
        
        if !weight.isValidNumericInput() {
            invalidFields.append("Weight")
        }
        
        if !height.isValidNumericInput() {
            invalidFields.append("Height")
        }
        
        if selectedGender == .notSelected {
            missingSelections.append("Gender")
        }
        
        if selectedActivity == .notSelected {
            missingSelections.append("Activity Level")
        }
        
        var messages: [String] = []
        
        if !invalidFields.isEmpty {
            messages.append("Enter a valid \(formatList(invalidFields)).")
        }
        
        if !missingSelections.isEmpty {
            messages.append("Select \(formatList(missingSelections)).")
        }
        
        return messages.isEmpty ? nil : messages.joined(separator: "\n")
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
    
    func handleRdiSave() -> Bool {
        if let errors = validateInputs() {
            alertMessage = errors
            showAlert = true
            return false
        }
        
        return true
    }
    
    private var isInputValidForCalculation: Bool {
        age.isValidNumericInput(in: 1...120) &&
        weight.isValidNumericInput() &&
        height.isValidNumericInput()
    }
    
    // MARK: - Text
    func text(for calculatedRdi: String) -> String {
        guard let rdiValue = calculatedRdi.doubleValue,
              rdiValue > 0,
              isInputValidForCalculation else {
            return "Fill in the data"
        }
        
        let formattedValue = rdiValue.asWhole()
        
        return rdiValue == 1
        ? "\(formattedValue) calorie"
        : "\(formattedValue) calories"
    }
    
    var rdiText: String {
        text(for: calculatedRdi)
    }
    
    func color(for calculatedRdi: String) -> Color {
        guard !calculatedRdi.isEmpty,
              isInputValidForCalculation else {
            return .secondary.opacity(0.5)
        }
        
        return .primary
    }
    
    // MARK: - Keyboard
    func normalizeAge() {
        if let value = age.doubleValue, value >= 1 && value <= 120 {
            age = age.trimmedLeadingZeros
        } else {
            age = ""
        }
    }
    
    func normalizeWeight() {
        weight = weight.trimmedLeadingZeros
    }
    
    func normalizeHeight() {
        height = height.trimmedLeadingZeros
    }
}

extension RdiViewModel: RdiViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewRdiView.rdiView
}
