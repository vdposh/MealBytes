//
//  CustomIntakeViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 12.08.2026.
//

import SwiftUI
import Combine

protocol CustomIntakeViewModelProtocol {
    var isValid: Bool { get }
    
    func loadCustomIntake() async
    func saveCustomIntakeView() async
    func conditionallyClearCustomIntake()
    func clearCustomIntake()
    func normalizeInputs()
}

final class CustomIntakeViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var calories: String = ""
    @Published var protein: String = ""
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
    @Published var isValid: Bool = false
    @Published var didSaveSuccessfully: Bool = false
    @Published var didLoadNonEmptyCustomIntake: Bool = false
    
    private let mainViewModel: MainViewModelProtocol
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
        
        setupBindingsCustomIntakeView()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Load CustomIntake Data
    func loadCustomIntake() async {
        do {
            let data = try await firestore.loadCustomIntakeFirestore()
            
            await MainActor.run {
                calories = data.calories
                fat = data.fat
                carbohydrate = data.carbohydrate
                protein = data.protein
                didLoadNonEmptyCustomIntake = !data.calories.isEmpty ||
                !data.fat.isEmpty ||
                !data.carbohydrate.isEmpty ||
                !data.protein.isEmpty
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    func conditionallyClearCustomIntake() {
        if !didSaveSuccessfully && !didLoadNonEmptyCustomIntake {
            clearCustomIntake()
        }
        
        didSaveSuccessfully = false
        didLoadNonEmptyCustomIntake = false
    }
    
    func clearCustomIntake() {
        calories = ""
        protein = ""
        fat = ""
        carbohydrate = ""
        isValid = false
    }
    
    // MARK: - Save CustomIntake Data
    func saveCustomIntakeData() async {
        let data = CustomIntake(
            calories: calories.trimmedLeadingZeros,
            fat: fat.trimmedLeadingZeros,
            carbohydrate: carbohydrate.trimmedLeadingZeros,
            protein: protein.trimmedLeadingZeros
        )
        
        do {
            try await firestore.saveCustomIntakeFirestore(data)
            
            await MainActor.run {
                mainViewModel.updateMacros(
                    fat: fat.trimmedLeadingZeros,
                    carbohydrate: carbohydrate.trimmedLeadingZeros,
                    protein: protein.trimmedLeadingZeros
                )
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    func saveCustomIntakeView() async {
        await saveCustomIntakeData()
        
        let trimmedCalories = calories.trimmedLeadingZeros
        
        await MainActor.run {
            mainViewModel.updateIntake(to: trimmedCalories)
            mainViewModel.updateMacros(
                fat: fat.trimmedLeadingZeros,
                carbohydrate: carbohydrate.trimmedLeadingZeros,
                protein: protein.trimmedLeadingZeros
            )
            didSaveSuccessfully = true
        }
        
        await mainViewModel.saveCurrentIntakeMainView(
            source: IntakeSource.custom.rawValue
        )
    }
    
    // MARK: - Calculation
    private func setupBindingsCustomIntakeView() {
        let fields = Publishers.CombineLatest4(
            $calories,
            $fat,
            $carbohydrate,
            $protein
        )
        
        fields
            .sink { [weak self] calories, fat, carb, protein in
                guard let self else { return }
                
                self.isValid = self.validate(
                    calories: calories,
                    fat: fat,
                    carbohydrate: carb,
                    protein: protein
                )
            }
            .store(in: &cancellables)
        
        fields
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self, self.isValid else { return }
                
                Task {
                    await self.saveCustomIntakeView()
                }
            }
            .store(in: &cancellables)
    }
    
    private func validate(
        calories: String,
        fat: String,
        carbohydrate: String,
        protein: String
    ) -> Bool {
        let hasAnyValue = !calories.isEmpty ||
        !fat.isEmpty ||
        !carbohydrate.isEmpty ||
        !protein.isEmpty
        
        guard hasAnyValue else { return false }
        
        if !calories.isEmpty && !calories.isValidNumericInput() {
            return false
        }
        if !fat.isEmpty && !fat.isValidNumericInput() {
            return false
        }
        if !carbohydrate.isEmpty && !carbohydrate.isValidNumericInput() {
            return false
        }
        if !protein.isEmpty && !protein.isValidNumericInput() {
            return false
        }
        
        return true
    }
    
    // MARK: - Keyboard
    func normalizeInputs() {
        calories = calories.trimmedLeadingZeros
        protein = protein.trimmedLeadingZeros
        fat = fat.trimmedLeadingZeros
        carbohydrate = carbohydrate.trimmedLeadingZeros
    }
    
    func handleFocusChange(
        focus: CustomIntakeFocus,
        didGainFocus: Bool
    ) {
        normalizeInputs()
        
        switch focus {
        case .calories:
            if didGainFocus {
            } else if calories.isValidNumericInput() {
                calories = calories.trimmedLeadingZeros
            }
            
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

extension CustomIntakeViewModel: CustomIntakeViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}
