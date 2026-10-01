//
//  MacrosIntakeViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI
import Combine

protocol MacrosIntakeViewModelProtocol {
    var isValid: Bool { get }
    
    func loadMacrosIntakeView() async
    func saveMacrosIntakeView() async
    func conditionallyClearMacrosIntake()
    func clearMacrosIntake()
    func normalizeInputs()
}

final class MacrosIntakeViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var calories: String = ""
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
    @Published var protein: String = ""
    @Published var isValid: Bool = false
    @Published var didSaveSuccessfully: Bool = false
    @Published var didLoadNonEmptyIntake: Bool = false
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let mainViewModel: MainViewModelProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
        
        setupBindingsMacrosIntakeView()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Load MacrosIntake Data
    func loadMacrosIntakeView() async {
        do {
            let macrosIntakeData = try await firestore
                .loadMacrosIntakeFirestore()
            
            await MainActor.run {
                calories = macrosIntakeData.calories
                fat = macrosIntakeData.fat
                carbohydrate = macrosIntakeData.carbohydrate
                protein = macrosIntakeData.protein
                didLoadNonEmptyIntake = !macrosIntakeData.calories.isEmpty
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    func conditionallyClearMacrosIntake() {
        if !didSaveSuccessfully && !didLoadNonEmptyIntake {
            clearMacrosIntake()
        }
        
        didSaveSuccessfully = false
        didLoadNonEmptyIntake = false
    }
    
    func clearMacrosIntake() {
        calories = ""
        fat = ""
        carbohydrate = ""
        protein = ""
        isValid = false
    }
    
    // MARK: - Save MacrosIntake Data
    func saveMacrosIntakeData() async {
        let macrosIntakeData = MacrosIntake(
            calories: calories.trimmedLeadingZeros,
            fat: fat.trimmedLeadingZeros,
            carbohydrate: carbohydrate.trimmedLeadingZeros,
            protein: protein.trimmedLeadingZeros
        )
        
        do {
            try await firestore.saveMacrosIntakeFirestore(macrosIntakeData)
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    func saveMacrosIntakeView() async {
        await saveMacrosIntakeData()
        
        await MainActor.run {
            didSaveSuccessfully = true
        }
        
        await mainViewModel.saveCurrentIntakeMainView(
            source: IntakeSource.macros.rawValue
        )
    }
    
    // MARK: - Calculation
    private func setupBindingsMacrosIntakeView() {
        let fields = Publishers.CombineLatest3($fat, $carbohydrate, $protein)
        
        fields
            .sink { [weak self] fat, carb, protein in
                guard let self else { return }
                
                self.calculateCalories(
                    fat: fat,
                    carbohydrate: carb,
                    protein: protein
                )
                
                self.isValid = self.validate(
                    fat: fat,
                    carbohydrate: carb,
                    protein: protein
                )
            }
            .store(in: &cancellables)
    }
    
    private func validate(
        fat: String,
        carbohydrate: String,
        protein: String
    ) -> Bool {
        fat.isValidNumericInput() &&
        carbohydrate.isValidNumericInput() &&
        protein.isValidNumericInput()
    }
    
    private func calculateCalories(
        fat: String,
        carbohydrate: String,
        protein: String
    ) {
        let fatValue = fat.doubleValue ?? 0
        let carbValue = carbohydrate.doubleValue ?? 0
        let protValue = protein.doubleValue ?? 0
        
        let totalCalories = (fatValue * 9) + (carbValue * 4) + (protValue * 4)
        
        calories = totalCalories > 0
        ? totalCalories.asWhole()
        : "0"
    }
    
    // MARK: - Keyboard
    func normalizeInputs() {
        calories = calories.trimmedLeadingZeros
        fat = fat.trimmedLeadingZeros
        carbohydrate = carbohydrate.trimmedLeadingZeros
        protein = protein.trimmedLeadingZeros
    }
    
    // MARK: - Focus
    func handleFocusChange(
        focus: MacronutrientsFocus,
        didGainFocus: Bool
    ) {
        normalizeInputs()
        
        switch focus {
        case .fat:
            if didGainFocus {
            } else if fat.isValidNumericInput() {
                fat = fat.trimmedLeadingZeros
            }
            
        case .carbohydrate:
            if didGainFocus {
            } else if carbohydrate.isValidNumericInput() {
                carbohydrate = carbohydrate.trimmedLeadingZeros
            }
            
        case .protein:
            if didGainFocus {
            } else if protein.isValidNumericInput() {
                protein = protein.trimmedLeadingZeros
            }
        }
    }
}

extension MacrosIntakeViewModel: MacrosIntakeViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewGoalsView.goalsView
}
