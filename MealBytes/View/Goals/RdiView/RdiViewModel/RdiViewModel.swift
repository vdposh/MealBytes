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
    @Published var selectedWeightGoal: WeightGoal = .notSelected
    @Published var calculatedRdi: String = ""
    @Published var didSaveSuccessfully: Bool = false
    @Published var didLoadNonEmptyRdi: Bool = false
    
    var proteinPercentage: Double = 0.30
    var fatPercentage: Double = 0.20
    var carbsPercentage: Double = 0.50
    
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
                self.selectedWeightGoal = WeightGoal(
                    rawValue: rdiData.selectedWeightGoal
                ) ?? .notSelected
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
            selectedHeightUnit: selectedHeightUnit.rawValue,
            selectedWeightGoal: selectedWeightGoal.rawValue
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
            Publishers.CombineLatest(
                Publishers.CombineLatest($age, $weight),
                Publishers.CombineLatest($height, $selectedGender)
            ),
            Publishers.CombineLatest(
                Publishers
                    .CombineLatest($selectedActivity, $selectedWeightUnit),
                Publishers
                    .CombineLatest($selectedHeightUnit, $selectedWeightGoal)
            )
        )
        .sink { [weak self] combined1, combined2 in
            let ((age, weight), (height, gender)) = combined1
            let ((activity, weightUnit), (heightUnit, weightGoal)) = combined2
            
            self?.recalculateRdi(
                age: age,
                weight: weight,
                height: height,
                gender: gender,
                activity: activity,
                weightUnit: weightUnit,
                heightUnit: heightUnit,
                weightGoal: weightGoal
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
        heightUnit: HeightUnit,
        weightGoal: WeightGoal
    ) {
        guard isValid,
              gender != .notSelected,
              activity != .notSelected,
              weightGoal != .notSelected else {
            calculatedRdi = ""
            return
        }
        
        let ageValue = age.doubleValue ?? 0
        let weightValue = weight.doubleValue ?? 0
        let heightValue = height.doubleValue ?? 0
        let weightInKg = weightUnit == .lbs ? weightValue * 0.453592 : weightValue
        let heightInCm = heightUnit == .inches ? heightValue * 2.54 : heightValue
        
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
        
        let tdee = bmr * activityFactor
        
        let adjustedCalories: Double
        switch weightGoal {
        case .lose:
            adjustedCalories = tdee * 0.85
        case .maintain:
            adjustedCalories = tdee
        case .gain:
            adjustedCalories = tdee * 1.15
        case .notSelected:
            adjustedCalories = tdee
        }
        
        calculatedRdi = max(1, adjustedCalories).asWhole()
    }
    
    var macroNutrients: (protein: Double, fat: Double, carbs: Double)? {
        guard let calories = calculatedRdi.doubleValue, calories > 0 else {
            return nil
        }
        
        let proteinGrams = (calories * proteinPercentage) / 4
        let fatGrams = (calories * fatPercentage) / 9
        let carbsGrams = (calories * carbsPercentage) / 4
        
        return (proteinGrams, fatGrams, carbsGrams)
    }
    
    var isValid: Bool {
        age.isValidNumericInput(in: 1...120) &&
        weight.isValidNumericInput() &&
        height.isValidNumericInput()
    }
    
    // MARK: - Text
    func text(for calculatedRdi: String, useUnit: Bool = true) -> String {
        guard let rdiValue = calculatedRdi.doubleValue,
              rdiValue > 0,
              isValid else {
            return "Fill in the data"
        }
        
        let formattedValue = rdiValue.asWhole()
        
        guard useUnit else {
            return formattedValue
        }
        
        return rdiValue == 1
        ? "\(formattedValue) calorie"
        : "\(formattedValue) calories"
    }
    
    var rdiText: String {
        text(for: calculatedRdi)
    }
    
    // MARK: - Keyboard
    func normalizeAge() {
        if let value = age.doubleValue {
            if value >= 1 && value <= 120 {
                age = age.trimmedLeadingZeros
            } else if value > 120 {
                age = "120"
            } else {
                age = ""
            }
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
