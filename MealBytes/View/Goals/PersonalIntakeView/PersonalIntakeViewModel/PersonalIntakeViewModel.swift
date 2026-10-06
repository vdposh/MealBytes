//
//  PersonalIntakeViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI
import Combine

protocol PersonalIntakeViewModelProtocol {
    var isValid: Bool { get }
    
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
    @Published var selectedSex: Sex = .notSet
    @Published var selectedActivity: Activity = .notSelected
    @Published var selectedWeightUnit: WeightUnit = .kg
    @Published var selectedHeightUnit: HeightUnit = .cm
    @Published var selectedWeightGoal: WeightGoal = .maintain
    @Published var selectedDistribution: MacroDistribution = .balanced
    @Published var calculatedPersonalIntake: String = ""
    @Published var isValid: Bool = false
    @Published var didSaveSuccessfully: Bool = false
    @Published var didLoadNonEmptyPersonalIntake: Bool = false
    @Published var isExpandedAge: Bool = false
    @Published var isExpandedWeight: Bool = false
    @Published var isExpandedHeight: Bool = false
    
    var proteinPercentage: Double { selectedDistribution.protein }
    var fatPercentage: Double { selectedDistribution.fat }
    var carbsPercentage: Double { selectedDistribution.carbs }
    
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
            || !personalIntakeData.age.isEmpty
            || !personalIntakeData.weight.isEmpty
            || !personalIntakeData.height.isEmpty
            
            await MainActor.run {
                self.calculatedPersonalIntake = personalIntakeData
                    .calculatedPersonalIntake
                self.age = personalIntakeData.age
                self.selectedSex = Sex(
                    rawValue: personalIntakeData.selectedSex
                ) ?? .notSet
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
                ) ?? .maintain
                self.selectedDistribution = MacroDistribution(
                    rawValue: personalIntakeData.selectedDistribution ?? ""
                ) ?? .balanced
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
        selectedSex = .notSet
        selectedActivity = .notSelected
        selectedWeightUnit = .kg
        selectedHeightUnit = .cm
        selectedWeightGoal = .maintain
        selectedDistribution = .balanced
        isValid = false
    }
    
    // MARK: - Save PersonalIntake Data
    func savePersonalIntakeData() async {
        let personalIntakeData = PersonalIntakeData(
            calculatedPersonalIntake: calculatedPersonalIntake,
            age: age.trimmedLeadingZeros,
            selectedSex: selectedSex.rawValue,
            selectedActivity: selectedActivity.rawValue,
            weight: String(weight.doubleValue ?? 0),
            selectedWeightUnit: selectedWeightUnit.rawValue,
            height: String(height.doubleValue ?? 0),
            selectedHeightUnit: selectedHeightUnit.rawValue,
            selectedWeightGoal: selectedWeightGoal.rawValue,
            selectedDistribution: selectedDistribution.rawValue
        )
        
        do {
            try await firestore.savePersonalIntakeFirestore(personalIntakeData)
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    func savePersonalIntakeView() async {
        await savePersonalIntakeData()
        
        await MainActor.run {
            didSaveSuccessfully = true
        }
        
        await mainViewModel
            .saveCurrentIntakeMainView(
                source: IntakeSource.personal.rawValue
            )
    }
    
    // MARK: - Calculation
    private func setupBindingsPersonalIntakeView() {
        let fields = Publishers.CombineLatest(
            Publishers.CombineLatest(
                Publishers.CombineLatest($age, $weight),
                Publishers.CombineLatest($height, $selectedSex)
            ),
            Publishers.CombineLatest(
                Publishers
                    .CombineLatest($selectedActivity, $selectedWeightUnit),
                Publishers
                    .CombineLatest($selectedHeightUnit, $selectedWeightGoal)
            )
        )
        
        fields
            .sink { [weak self] combined1, combined2 in
                let ((age, weight), (height, sex)) = combined1
                let ((activity, weightUnit), (heightUnit, weightGoal)) = combined2
                
                self?.recalculatePersonalIntake(
                    age: age,
                    weight: weight,
                    height: height,
                    sex: sex,
                    activity: activity,
                    weightUnit: weightUnit,
                    heightUnit: heightUnit,
                    weightGoal: weightGoal
                )
                
                self?.isValid = self?.validate(
                    age: age,
                    weight: weight,
                    height: height,
                    activity: activity,
                    weightGoal: weightGoal
                ) ?? false
            }
            .store(in: &cancellables)
    }
    
    private func validate(
        age: String,
        weight: String,
        height: String,
        activity: Activity,
        weightGoal: WeightGoal
    ) -> Bool {
        !age.isEmpty &&
        weight.isValidNumericInput() &&
        height.isValidNumericInput() &&
        activity != .notSelected
    }
    
    private func recalculatePersonalIntake(
        age: String,
        weight: String,
        height: String,
        sex: Sex,
        activity: Activity,
        weightUnit: WeightUnit,
        heightUnit: HeightUnit,
        weightGoal: WeightGoal
    ) {
        guard !age.isEmpty,
              weight.isValidNumericInput(),
              height.isValidNumericInput(),
              activity != .notSelected else {
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
        
        switch sex {
        case .male:
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * ageValue + 5
        case .female:
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * ageValue - 161
        case .notSet:
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * ageValue - 78
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
        }
        
        calculatedPersonalIntake = max(1, adjustedCalories).asWhole()
    }
    
    // MARK: - UI Helper
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
    
    var formattedAge: String {
        guard let age = Int(age) else {
            return age
        }
        return "\(age) \(age == 1 ? "year" : "years")"
    }
    
    var macroValues: [NutrientType: String] {
        let caloriesKcal = calculatedPersonalIntake.doubleValue ?? 0
        let caloriesDisplay = energyUnit.convert(fromKcal: caloriesKcal)
        
        return [
            .calories: caloriesDisplay.asWhole(),
            .fat: (macroNutrients?.fat ?? 0).asWhole(),
            .carbohydrate: (macroNutrients?.carbs ?? 0).asWhole(),
            .protein: (macroNutrients?.protein ?? 0).asWhole()
        ]
    }
    
    var energyUnit: EnergyUnit {
        mainViewModel.energyUnit
    }
    
    var weightText: String {
        guard let value = weight.doubleValue, value > 0 else { return "" }
        return "\(weight) \(selectedWeightUnit.rawValue)"
    }
    
    var heightText: String {
        guard let value = height.doubleValue, value > 0 else { return "" }
        return "\(height) \(selectedHeightUnit.rawValue)"
    }
    
    func collapseAllSections() {
        isExpandedAge = false
        isExpandedWeight = false
        isExpandedHeight = false
    }
    
    func toggleSection(_ section: PersonalSection) {
        let willExpand = !isSectionExpanded(section)
        
        isExpandedAge = false
        isExpandedWeight = false
        isExpandedHeight = false
        
        if willExpand {
            setSection(section, expanded: true)
        }
    }
    
    private func isSectionExpanded(_ section: PersonalSection) -> Bool {
        switch section {
        case .age: return isExpandedAge
        case .weight: return isExpandedWeight
        case .height: return isExpandedHeight
        }
    }
    
    private func setSection(_ section: PersonalSection, expanded: Bool) {
        switch section {
        case .age: isExpandedAge = expanded
        case .weight: isExpandedWeight = expanded
        case .height: isExpandedHeight = expanded
        }
    }
    
    enum PersonalSection {
        case age, weight, height
    }
}

extension PersonalIntakeViewModel: PersonalIntakeViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewGoalsView.goalsView
}
