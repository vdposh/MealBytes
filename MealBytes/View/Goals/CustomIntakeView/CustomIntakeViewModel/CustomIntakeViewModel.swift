//
//  CustomIntakeViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 12.08.2026.
//

import SwiftUI

protocol CustomIntakeViewModelProtocol {
    var customIntakeText: String { get }
    
    func loadCustomIntake() async
    func saveCustomIntake() async
    func conditionallyClearCustomIntake()
    func clearCustomIntake()
}

final class CustomIntakeViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var calories: String = ""
    @Published var didSaveSuccessfully: Bool = false
    @Published var didLoadNonEmptyCustomIntake: Bool = false
    
    private let mainViewModel: MainViewModelProtocol
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    
    init(mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
    }
    
    // MARK: - Load CustomIntake Data
    func loadCustomIntake() async {
        do {
            let data = try await firestore.loadCustomIntakeFirestore()
            await MainActor.run {
                calories = data.calories
                didLoadNonEmptyCustomIntake = !data.calories.isEmpty
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
    }
    
    // MARK: - Save CustomIntake Data
    func saveCustomIntake() async {
        guard isValid else { return }
        
        let data = CustomIntake(calories: calories)
        
        do {
            try await firestore.saveCustomIntakeFirestore(data)
            
            await MainActor.run {
                mainViewModel.updateIntake(to: calories)
                didSaveSuccessfully = true
            }
            
            await mainViewModel.saveCurrentIntakeMainView(source: "customView")
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Text
    func text(for calories: String) -> String {
        guard let caloriesValue = calories.doubleValue,
              caloriesValue > 0 else {
            return "Fill in the data"
        }
        
        let formattedValue = caloriesValue.asWhole()
        
        return caloriesValue == 1
        ? "\(formattedValue) calorie"
        : "\(formattedValue) calories"
    }
    
    var customIntakeText: String {
        text(for: calories)
    }
    
    // MARK: - Keyboard
    func normalizeCalories() {
        calories = calories.trimmedLeadingZeros
    }
    
    var isValid: Bool {
        calories.isValidNumericInput()
    }
}

extension CustomIntakeViewModel: CustomIntakeViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}
