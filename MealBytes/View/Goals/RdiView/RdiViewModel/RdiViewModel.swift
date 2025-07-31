//
//  RdiViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI
import Combine

protocol RdiViewModelProtocol {
    func loadRdiView() async
    func saveRdiView() async
    func clearRdi()
    func rdiText() -> String
}

final class RdiViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var age: String = ""
    @Published var weight: String = ""
    @Published var height: String = ""
    @Published var selectedGender: Gender = .notSelected
    @Published var selectedActivity: Activity = .notSelected
    @Published var selectedWeightUnit: WeightUnit = .notSelected
    @Published var selectedHeightUnit: HeightUnit = .notSelected
    @Published var calculatedRdi: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    private let formatter = Formatter()
    
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
            await MainActor.run {
                self.calculatedRdi = rdiData.calculatedRdi
                self.age = rdiData.age
                self.selectedGender = Gender(
                    rawValue: rdiData.selectedGender
                ) ?? .notSelected
                self.selectedActivity = Activity(
                    rawValue: rdiData.selectedActivity
                ) ?? .notSelected
                self.weight = rdiData.weight.preparedForLocaleDecimal
                self.selectedWeightUnit = WeightUnit(
                    rawValue: rdiData.selectedWeightUnit
                ) ?? .notSelected
                self.height = rdiData.height.preparedForLocaleDecimal
                self.selectedHeightUnit = HeightUnit(
                    rawValue: rdiData.selectedHeightUnit
                ) ?? .notSelected
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    func clearRdi() {
        calculatedRdi = ""
        age = ""
        weight = ""
        height = ""
        selectedGender = .notSelected
        selectedActivity = .notSelected
        selectedWeightUnit = .notSelected
        selectedHeightUnit = .notSelected
    }
    
    // MARK: - Save RDI Data
    func saveRdiView() async {
        let stableRdi = calculatedRdi
        
        let rdiData = RdiData(
            calculatedRdi: stableRdi,
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
                mainViewModel.updateIntake(to: stableRdi)
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
        case .notSelected: return
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
        var invalidFields: [String] = []
        var missingSelections: [String] = []
        var missingUnits: [String] = []
        
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
        
        if selectedWeightUnit == .notSelected {
            missingUnits.append("Weight")
        }
        if selectedHeightUnit == .notSelected {
            missingUnits.append("Height")
        }
        
        var messages: [String] = []
        
        if !invalidFields.isEmpty {
            messages.append("Enter a valid \(formatList(invalidFields))")
        }
        
        if !missingSelections.isEmpty {
            messages.append("Select \(formatList(missingSelections))")
        }
        
        if !missingUnits.isEmpty {
            let isPlural = missingUnits.count != 1
            let unitMessage = isPlural
            ? "Specify units for \(formatList(missingUnits))"
            : "Specify unit for \(formatList(missingUnits))"
            messages.append(unitMessage)
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
    
    func handleSave() -> Bool {
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
    
    func rdiText() -> String {
        text(for: calculatedRdi)
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
    
    // MARK: - Keyboard
    func normalizeInputs() {
        age = age.trimmedLeadingZeros
        weight = weight.trimmedLeadingZeros
        height = height.trimmedLeadingZeros
    }
    
    // MARK: - Focus
    func handleFocusChange(from previous: RdiFocus?) {
        normalizeInputs()
        
        if let old = previous {
            switch old {
            case .age:
                if age.isValidNumericInput(in: 1...120) {
                    age = age.trimmedLeadingZeros
                }
                
            case .weight:
                if weight.isValidNumericInput() {
                    weight = weight.trimmedLeadingZeros
                }
                
            case .height:
                if height.isValidNumericInput() {
                    height = height.trimmedLeadingZeros
                }
            }
        }
    }
}

extension RdiViewModel: RdiViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    let mainViewModel = MainViewModel()
    let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)
    
    return NavigationStack {
        RdiView(rdiViewModel: rdiViewModel)
    }
}
