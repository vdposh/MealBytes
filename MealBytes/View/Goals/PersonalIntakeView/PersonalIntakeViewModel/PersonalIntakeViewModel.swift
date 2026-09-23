//
//  PersonalIntakeViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI
import Combine

protocol PersonalIntakeViewModelProtocol {
    var personalIntakeText: String { get }
    
    func loadPersonalIntakeView() async
    func savePersonalIntakeView() async
    func clearPersonalIntake()
    func conditionallyClearPersonalIntake()
}

final class PersonalIntakeViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var age: String = ""
    @Published var weight: String = ""
    @Published var height: String = ""
    @Published var selectedGender: Gender = .notSelected
    @Published var selectedActivity: Activity = .notSelected
    @Published var selectedWeightUnit: WeightUnit = .kg
    @Published var selectedHeightUnit: HeightUnit = .cm
    @Published var selectedWeightGoal: WeightGoal = .notSelected
    @Published var calculatedPersonalIntake: String = ""
    @Published var didSaveSuccessfully: Bool = false
    @Published var didLoadNonEmptyPersonalIntake: Bool = false
    
    var proteinPercentage: Double = 0.30
    var fatPercentage: Double = 0.20
    var carbsPercentage: Double = 0.50
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let mainViewModel: MainViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
        
        setupBindingsPersonalIntakeView()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Load PersonalIntake Data
    func loadPersonalIntakeView() async {
        do {
            let personalIntakeData = try await firestore
                .loadPersonalIntakeFirestore()
            let hasAnyData = !personalIntakeData
                .calculatedPersonalIntake.isEmpty
            
            await MainActor.run {
                self.calculatedPersonalIntake = personalIntakeData
                    .calculatedPersonalIntake
                self.age = personalIntakeData.age
                self.selectedGender = Gender(
                    rawValue: personalIntakeData.selectedGender
                ) ?? .notSelected
                self.selectedActivity = Activity(
                    rawValue: personalIntakeData.selectedActivity
                ) ?? .notSelected
                self.weight = (Double(personalIntakeData.weight) ?? 0)
                    .asDecimal()
                self.selectedWeightUnit = WeightUnit(
                    rawValue: personalIntakeData.selectedWeightUnit
                ) ?? .kg
                self.height = (Double(personalIntakeData.height) ?? 0)
                    .asDecimal()
                self.selectedHeightUnit = HeightUnit(
                    rawValue: personalIntakeData.selectedHeightUnit
                ) ?? .cm
                self.selectedWeightGoal = WeightGoal(
                    rawValue: personalIntakeData.selectedWeightGoal
                ) ?? .notSelected
                self.didLoadNonEmptyPersonalIntake = hasAnyData
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    func conditionallyClearPersonalIntake() {
        if !didSaveSuccessfully && !didLoadNonEmptyPersonalIntake {
            clearPersonalIntake()
        }
        
        didSaveSuccessfully = false
        didLoadNonEmptyPersonalIntake = false
    }
    
    func clearPersonalIntake() {
        calculatedPersonalIntake = ""
        age = ""
        weight = ""
        height = ""
        selectedGender = .notSelected
        selectedActivity = .notSelected
        selectedWeightUnit = .kg
        selectedHeightUnit = .cm
    }
    
    // MARK: - Save PersonalIntake Data
    func savePersonalIntakeView() async {
        let stablePersonalIntake = String(
            calculatedPersonalIntake.doubleValue ?? 0
        )
        
        let personalIntakeData = PersonalIntakeData(
            calculatedPersonalIntake: stablePersonalIntake,
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
            try await firestore.savePersonalIntakeFirestore(personalIntakeData)
            
            await MainActor.run {
                mainViewModel.updateIntake(to: stablePersonalIntake)
                didSaveSuccessfully = true
            }
            
            await mainViewModel
                .saveCurrentIntakeMainView(source: "personalIntakeView")
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Calculation
    private func setupBindingsPersonalIntakeView() {
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
            
            self?.recalculatePersonalIntake(
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
    
    private func recalculatePersonalIntake(
        age: String,
        weight: String,
        height: String,
        gender: Gender,
        activity: Activity,
        weightUnit: WeightUnit,
        heightUnit: HeightUnit,
        weightGoal: WeightGoal
    ) {
        guard age.isValidNumericInput(in: 1...120),
              weight.isValidNumericInput(),
              height.isValidNumericInput(),
              gender != .notSelected,
              activity != .notSelected,
              weightGoal != .notSelected else {
            calculatedPersonalIntake = ""
            return
        }
        
        let ageValue = age.doubleValue ?? 0
        let weightValue = weight.doubleValue ?? 0
        let heightValue = height.doubleValue ?? 0
        let weightInKg = weightUnit ==
            .lbs ? weightValue * 0.453592 : weightValue
        let heightInCm = heightUnit ==
            .inches ? heightValue * 2.54 : heightValue
        
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
        
        calculatedPersonalIntake = max(1, adjustedCalories).asWhole()
    }
    
    var macroNutrients: (protein: Double, fat: Double, carbs: Double)? {
        guard let calories = calculatedPersonalIntake.doubleValue,
              calories > 0 else {
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
        height.isValidNumericInput() &&
        selectedGender != .notSelected &&
        selectedActivity != .notSelected &&
        selectedWeightGoal != .notSelected
    }
    
    // MARK: - Text
    func text(
        for calculatedPersonalIntake: String,
        useUnit: Bool = true
    ) -> String {
        guard let personalIntakeValue = calculatedPersonalIntake.doubleValue,
              personalIntakeValue > 0,
              isValid else {
            return "Fill in the data"
        }
        
        let formattedValue = personalIntakeValue.asWhole()
        
        guard useUnit else {
            return formattedValue
        }
        
        return personalIntakeValue == 1
        ? "\(formattedValue) calorie"
        : "\(formattedValue) calories"
    }
    
    var personalIntakeText: String {
        text(for: calculatedPersonalIntake)
    }
    
    var bodyProfileText: String {
        let gender = selectedGender ==
            .notSelected ? "" : selectedGender.rawValue
        let age = age.isEmpty ? "" : formattedAge
        
        return [gender, age]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
    
    var formattedAge: String {
        guard let age = Int(age) else {
            return age
        }
        return "\(age) \(age == 1 ? "year" : "years")"
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

extension PersonalIntakeViewModel: PersonalIntakeViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewPersonalIntakeView.personalIntakeView
}
